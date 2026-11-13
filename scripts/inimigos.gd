extends CharacterBody2D

signal morreu(inimigo)


enum TipoInimigo {
	NORMAL,
	RAPIDO,
	TANQUE,
	BOSS
}

@export var tipo: TipoInimigo = TipoInimigo.NORMAL


@export_category("Vida")
@export var vida_maxima := 50

@export_category("Movimento")
@export var velocidade := 70.0

@export_category("Ataque")
@export var distancia_ataque := 48.0
@export var distancia_impacto := 30.0
@export var dano := 10
@export var intervalo_ataque := 0.9
@export var tempo_impacto := 0.25

@export_category("Knockback")
@export var knockback_forca := 260.0
@export var knockback_duracao := 0.22
@export var resistencia_knockback := 1.0

@export_category("Pontuação")
@export var pontuacao := 10


# Injetado pelo Diluc_minigame.gd ANTES de add_child(), então já
# está disponível quando _ready() roda. Sem busca por grupo.
var jogador: Node2D = null

var vida := 0
var atacando := false
var morto := false
var recebendo_dano := false
var id_ataque := 0
var tempo_ate_proximo_ataque := 0.0

var knockback_velocity := Vector2.ZERO
var tempo_knockback := 0.0


@onready var sprite_normal: AnimatedSprite2D = $Normal
@onready var sprite_rapido: AnimatedSprite2D = $Rapido
@onready var sprite_tanque: AnimatedSprite2D = $Tanque
@onready var sprite_boss: AnimatedSprite2D = $Boss
@onready var area_dano: Area2D = $AreaDano

var sprite: AnimatedSprite2D = null


func _ready():

	add_to_group("inimigos")

	# CAMADAS: inimigo na layer 2. Colide com o player (layer 1), com OUTROS
	# inimigos (layer 2, mesma layer — evita empilhamento) e com os
	# limites da arena (layer 3).
	collision_layer = 1 << 1
	collision_mask = (1 << 0) | (1 << 1) | (1 << 2)

	# AreaDano: fica SEMPRE monitorando (nunca fazemos toggle). Evita
	# o mesmo problema de timing do broadphase do Godot.
	area_dano.collision_layer = 0
	area_dano.collision_mask = 1
	area_dano.monitoring = true
	area_dano.monitorable = false

	# Força ALWAYS diretamente na Area, sem depender só da herança
	# do CharacterBody2D pai — a detecção de overlap de uma Area2D
	# pode ser afetada pelo SceneTree.paused de forma diferente do
	# resto do processamento físico.
	area_dano.process_mode = Node.PROCESS_MODE_ALWAYS

	var shape = get_node_or_null("CollisionShape2D")
	if shape:
		shape.disabled = false
	else:
		print("ERRO: inimigo não possui CollisionShape2D")

	var shape_dano = area_dano.get_node_or_null("CollisionShape2D")
	if shape_dano:
		shape_dano.disabled = false

	# Também força no corpo físico do inimigo, por segurança.
	process_mode = Node.PROCESS_MODE_ALWAYS

	configurar_tipo()


func configurar_tipo():

	sprite_normal.visible = false
	sprite_rapido.visible = false
	sprite_tanque.visible = false
	sprite_boss.visible = false

	match tipo:

		TipoInimigo.NORMAL:
			sprite = sprite_normal
			vida_maxima = 50
			velocidade = 70.0
			dano = 10
			distancia_ataque = 48.0
			distancia_impacto = 30.0
			intervalo_ataque = 0.9
			tempo_impacto = 0.25
			knockback_forca = 260.0
			knockback_duracao = 0.22
			resistencia_knockback = 1.0
			pontuacao = 10

		TipoInimigo.RAPIDO:
			sprite = sprite_rapido
			vida_maxima = 30
			velocidade = 120.0
			dano = 7
			distancia_ataque = 46.0
			distancia_impacto = 28.0
			intervalo_ataque = 0.75
			tempo_impacto = 0.20
			knockback_forca = 290.0
			knockback_duracao = 0.24
			resistencia_knockback = 0.75
			pontuacao = 20

		TipoInimigo.TANQUE:
			sprite = sprite_tanque
			vida_maxima = 140
			velocidade = 42.0
			dano = 18
			distancia_ataque = 52.0
			distancia_impacto = 34.0
			intervalo_ataque = 1.2
			tempo_impacto = 0.30
			knockback_forca = 180.0
			knockback_duracao = 0.20
			resistencia_knockback = 2.0
			pontuacao = 40

		TipoInimigo.BOSS:
			sprite = sprite_boss
			vida_maxima = 500
			velocidade = 55.0
			dano = 25
			distancia_ataque = 58.0
			distancia_impacto = 38.0
			intervalo_ataque = 1.1
			tempo_impacto = 0.35
			knockback_forca = 140.0
			knockback_duracao = 0.18
			resistencia_knockback = 3.5
			pontuacao = 250

	sprite.visible = true
	vida = vida_maxima


func _physics_process(delta):

	if morto or not is_instance_valid(sprite):
		return

	if tempo_knockback > 0:
		tempo_knockback -= delta
		velocity = knockback_velocity
		move_and_slide()
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 650.0 * delta)

		if tempo_knockback <= 0:
			tempo_knockback = 0
			knockback_velocity = Vector2.ZERO
			if not recebendo_dano:
				atacando = false
		return

	if tempo_ate_proximo_ataque > 0:
		tempo_ate_proximo_ataque = max(tempo_ate_proximo_ataque - delta, 0.0)

	if not is_instance_valid(jogador):
		velocity = Vector2.ZERO
		return

	if jogador.morto:
		velocity = Vector2.ZERO
		if not atacando and not recebendo_dano:
			tocar_animacao("idle")
		return

	if recebendo_dano or atacando:
		velocity = Vector2.ZERO
		return

	var distancia := global_position.distance_to(jogador.global_position)

	if distancia > distancia_ataque:
		var direcao := global_position.direction_to(jogador.global_position)
		velocity = direcao * velocidade
		move_and_slide()
		animar_movimento(direcao)
		return

	velocity = Vector2.ZERO

	if tempo_ate_proximo_ataque <= 0:
		atacar_jogador()


func animar_movimento(direcao: Vector2):

	if morto or recebendo_dano or not is_instance_valid(sprite):
		return

	tocar_animacao("walking")

	if abs(direcao.x) > 0.1:
		sprite.flip_h = direcao.x > 0


func tocar_animacao(nome: String):

	if morto or recebendo_dano or not is_inside_tree() or not is_instance_valid(sprite):
		return

	if sprite.sprite_frames == null or not sprite.sprite_frames.has_animation(nome):
		return

	sprite.play(nome)


func atacar_jogador():

	if morto or atacando or recebendo_dano:
		return

	if not is_instance_valid(jogador) or not is_instance_valid(sprite):
		return

	atacando = true
	id_ataque += 1
	var meu_id := id_ataque

	velocity = Vector2.ZERO
	tocar_animacao("attack")

	await get_tree().create_timer(tempo_impacto).timeout

	if morto or meu_id != id_ataque or recebendo_dano or not is_inside_tree():
		return

	if not is_instance_valid(jogador):
		atacando = false
		return

	# Reposiciona a AreaDano AGORA, com a posição atual do jogador —
	# se calculado antes do await, o jogador já pode ter se movido
	# para fora do alcance durante os 0.2-0.35s de espera.
	var direcao := global_position.direction_to(jogador.global_position)
	area_dano.position = direcao * distancia_impacto

	await get_tree().physics_frame

	if morto or meu_id != id_ataque or recebendo_dano:
		return

	var corpos := area_dano.get_overlapping_bodies()

	for corpo in corpos:
		if corpo.is_in_group("player_diluc") and not corpo.morto:
			corpo.receber_dano(dano)
			if corpo.has_method("aplicar_knockback"):
				var direcao_kb := global_position.direction_to(corpo.global_position)
				corpo.aplicar_knockback(direcao_kb, 160.0)

	if is_instance_valid(sprite) and sprite.is_playing():
		await sprite.animation_finished

	if morto or meu_id != id_ataque or recebendo_dano:
		return

	atacando = false
	tempo_ate_proximo_ataque = intervalo_ataque


func receber_dano(valor):

	if morto:
		return

	vida = clamp(vida - valor, 0, vida_maxima)

	atualizar_barra_vida()

	if vida <= 0:
		morrer()
		return

	id_ataque += 1
	atacando = false
	recebendo_dano = true
	velocity = Vector2.ZERO

	if is_instance_valid(jogador):
		var direcao := jogador.global_position.direction_to(global_position)
		aplicar_knockback(direcao, knockback_forca)

	if is_instance_valid(sprite) and sprite.sprite_frames.has_animation("hurt"):
		sprite.play("hurt")
		await sprite.animation_finished

	if morto:
		return

	recebendo_dano = false


func aplicar_knockback(direcao: Vector2, forca: float):

	if morto or direcao == Vector2.ZERO:
		return

	var forca_real := forca / resistencia_knockback

	knockback_velocity = direcao.normalized() * forca_real
	tempo_knockback = knockback_duracao
	velocity = knockback_velocity


func atualizar_barra_vida():

	if morto:
		return

	var barra = get_node_or_null("BarraVida")
	if barra:
		barra.max_value = vida_maxima
		barra.value = vida


func get_pontuacao() -> int:
	return pontuacao


func get_tipo_nome() -> String:
	match tipo:
		TipoInimigo.NORMAL: return "NORMAL"
		TipoInimigo.RAPIDO: return "RAPIDO"
		TipoInimigo.TANQUE: return "TANQUE"
		TipoInimigo.BOSS: return "BOSS"
	return "DESCONHECIDO"


func morrer():

	if morto:
		return

	morto = true
	atacando = false
	recebendo_dano = false
	id_ataque += 1
	velocity = Vector2.ZERO
	tempo_ate_proximo_ataque = 999999.0

	collision_layer = 0
	collision_mask = 0
	area_dano.monitoring = false

	if is_instance_valid(sprite) and sprite.sprite_frames.has_animation("death"):
		sprite.play("death")
		await sprite.animation_finished

	if is_inside_tree():
		morreu.emit(self)

	queue_free()


func aplicar_escalonamento(onda: int):
	var multiplicador_vida := 1.0 + ((onda - 1) * 0.06)
	var multiplicador_dano := 1.0 + ((onda - 1) * 0.025)
	vida_maxima = int(vida_maxima * multiplicador_vida)
	dano = int(dano * multiplicador_dano)
	vida = vida_maxima

func tocar_som_spawn():

	if not is_instance_valid(sprite):
		return

	var som_vivo: AudioStreamPlayer = sprite.get_node_or_null("AudioStreamPlayer")

	if som_vivo:
		som_vivo.play()
