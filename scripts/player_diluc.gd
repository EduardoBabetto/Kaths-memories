extends CharacterBody2D

signal morreu
signal tomou_dano


@export_category("Movimento")
@export var velocidade_base := 180.0
@export var velocidade_ataque := 90.0

@export_category("Vida")
@export var vida_maxima := 100

@export_category("Espada")
@export var dano_espada := 25
@export var knockback_espada := 280.0

@export_category("Combate")
@export var tempo_impacto := 0.12
@export var cooldown_ataque := 0.20

@export_category("Roguelike")
@export var bonus_dano := 0
@export var bonus_velocidade := 0.0
@export var bonus_knockback := 0.0


var vida := 0
var direcao_olhando := Vector2.DOWN

var atacando := false
var morto := false
var pode_atacar := true
var invulneravel := false
var tempo_invulnerabilidade := 0.45

var knockback_velocity := Vector2.ZERO
var tempo_knockback := 0.0

var inimigos_atingidos: Array[Node] = []


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_ataque: Area2D = $AreaAtaque
@onready var som_espada: AudioStreamPlayer = $Espada


func _ready():

	vida = vida_maxima

	add_to_group("player_diluc")

	# CAMADAS: player na layer 1. Colide com inimigos (layer 2) e com os
	# limites da arena (layer 3).
	collision_layer = 1
	collision_mask = (1 << 1) | (1 << 2)

	# ESPADA: fica SEMPRE monitorando (nunca desligamos). Isso evita
	# um problema de timing do Godot onde ligar monitoring e checar
	# get_overlapping_bodies() logo em seguida pode não refletir o
	# estado real do physics broadphase ainda. O dano só é aplicado
	# durante a janela ativa do golpe (controlada por outro lado).
	area_ataque.collision_layer = 0
	area_ataque.collision_mask = 2
	area_ataque.monitoring = true
	area_ataque.monitorable = false

	# Força ALWAYS diretamente, sem depender só da herança —
	# a detecção de overlap de uma Area2D pode ser afetada pelo
	# SceneTree.paused de forma diferente do resto do processamento
	# físico.
	area_ataque.process_mode = Node.PROCESS_MODE_ALWAYS
	process_mode = Node.PROCESS_MODE_ALWAYS

	var shape = area_ataque.get_node_or_null("CollisionShape2D")
	if shape == null:
		print("ERRO: AreaAtaque não possui CollisionShape2D!")
	else:
		shape.disabled = false


func _physics_process(delta):

	if morto:
		return

	if tempo_knockback > 0:
		tempo_knockback -= delta
		velocity = knockback_velocity
		move_and_slide()
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 550.0 * delta)
		return

	if atacando:
		movimentar_durante_ataque()
		return

	movimentar()
	animar()


func movimentar():

	var direcao := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if direcao != Vector2.ZERO:
		direcao_olhando = direcao.normalized()
		ajustar_direcao_ataque()

	velocity = direcao * (velocidade_base + bonus_velocidade)
	move_and_slide()


func movimentar_durante_ataque():

	var direcao := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if direcao != Vector2.ZERO:
		direcao_olhando = direcao.normalized()
		ajustar_direcao_ataque()
		velocity = direcao * velocidade_ataque
	else:
		velocity = Vector2.ZERO

	move_and_slide()


# Mantém o offset em 42px (já ajustado por você no editor, com a
# CollisionShape2D da espada com raio 32px cobrindo de 10px a 74px
# de distância do player — cobre a distância de contato físico real
# com o inimigo).
func ajustar_direcao_ataque():
	area_ataque.position = direcao_olhando.normalized() * 42.0


func encontrar_inimigo_mais_proximo(raio_max: float) -> Node2D:
	var mais_perto: Node2D = null
	var menor_dist := raio_max
	for inimigo in get_tree().get_nodes_in_group("inimigos"):
		if "morto" in inimigo and inimigo.morto:
			continue
		var d = global_position.distance_to(inimigo.global_position)
		if d < menor_dist:
			menor_dist = d
			mais_perto = inimigo
	return mais_perto


func animar():

	if velocity == Vector2.ZERO:
		sprite.play("idle")
	else:
		sprite.play("walking")

	if abs(velocity.x) > 0.1:
		sprite.flip_h = velocity.x < 0


func _input(event):

	if morto:
		return

	if event.is_action_pressed("attack"):
		atacar()


func atacar():

	if not pode_atacar or morto:
		return

	pode_atacar = false
	atacando = true
	inimigos_atingidos.clear()

	# Auto-mira: se tiver um inimigo perto o suficiente, aponta a
	# espada para ele em vez de depender só da direção que o
	# player está olhando naquele frame.
	var alvo := encontrar_inimigo_mais_proximo(90.0)
	if alvo:
		direcao_olhando = global_position.direction_to(alvo.global_position)
	ajustar_direcao_ataque()

	sprite.play("attack")

	if som_espada:
		som_espada.play()

	await get_tree().create_timer(tempo_impacto).timeout

	if morto:
		finalizar_ataque()
		return

	aplicar_dano()

	if sprite.is_playing():
		await sprite.animation_finished

	finalizar_ataque()


func aplicar_dano():

	if morto:
		return

	var corpos := area_ataque.get_overlapping_bodies()

	for corpo in corpos:

		if not is_instance_valid(corpo):
			continue

		if not corpo.is_in_group("inimigos"):
			continue

		if corpo in inimigos_atingidos:
			continue

		if "morto" in corpo and corpo.morto:
			continue

		inimigos_atingidos.append(corpo)

		corpo.receber_dano(dano_espada + bonus_dano)

		if not corpo.morto and corpo.has_method("aplicar_knockback"):
			var direcao := global_position.direction_to(corpo.global_position)
			corpo.aplicar_knockback(direcao, knockback_espada + bonus_knockback)


func finalizar_ataque():
	atacando = false
	pode_atacar = true
	inimigos_atingidos.clear()


func receber_dano(dano):

	if morto or invulneravel:
		return

	invulneravel = true

	vida = clamp(vida - dano, 0, vida_maxima)

	tomou_dano.emit()

	if vida <= 0:
		morrer()
		return

	sprite.play("hurt")

	await get_tree().create_timer(tempo_invulnerabilidade).timeout

	invulneravel = false


func aplicar_knockback(direcao: Vector2, forca: float):

	if morto:
		return

	knockback_velocity = direcao.normalized() * forca
	tempo_knockback = 0.12
	velocity = knockback_velocity


func morrer():

	if morto:
		return

	morto = true
	atacando = false
	velocity = Vector2.ZERO
	inimigos_atingidos.clear()

	if sprite.sprite_frames.has_animation("death"):
		sprite.play("death")
		await sprite.animation_finished

	morreu.emit()


func aumentar_dano(valor: int):
	bonus_dano += valor

func aumentar_velocidade(valor: float):
	bonus_velocidade += valor

func aumentar_knockback(valor: float):
	bonus_knockback += valor

func recuperar_vida(valor: int):
	vida = clamp(vida + valor, 0, vida_maxima)
	tomou_dano.emit()

func aumentar_vida_maxima(valor: int):
	vida_maxima += valor
	vida = clamp(vida + valor, 0, vida_maxima)
	tomou_dano.emit()

func resetar_status():
	vida_maxima = 100
	vida = vida_maxima
	dano_espada = 25
	velocidade_base = 180.0
	knockback_espada = 280.0
	bonus_dano = 0
	bonus_velocidade = 0.0
	bonus_knockback = 0.0
	invulneravel = false
	atacando = false
	morto = false
	pode_atacar = true
	knockback_velocity = Vector2.ZERO
	tempo_knockback = 0.0
