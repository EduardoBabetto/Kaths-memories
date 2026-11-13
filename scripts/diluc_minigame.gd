extends Node2D

signal closed

enum TipoRecompensa {
	DANO,
	VIDA,
	VIDA_MAXIMA,
	VELOCIDADE,
	KNOCKBACK
}

enum Estado {
	MENU,
	JOGO,
	RESULTADO
}

enum TipoInimigo {
	NORMAL,
	RAPIDO,
	TANQUE,
	BOSS
}


var estado_atual = Estado.MENU

var onda_atual := 1
var inimigos_para_matar := 0
var inimigos_mortos := 0
var mudando_onda := false

var pontuacao := 0


@export var inimigo_scene: PackedScene

@export_category("Spawns")
@export var distancia_minima_spawn := 400.0
@export var intervalo_spawn_inicial := 0.45
@export var intervalo_spawn_minimo := 0.12


@onready var canvas: CanvasLayer = $CanvasLayer
@onready var menu = $CanvasLayer/Menu
@onready var background = $CanvasLayer/BackGround
@onready var botao_jogar = $CanvasLayer/Menu/Start_btn
@onready var botao_sair = $CanvasLayer/Menu/Quit_Btn
@onready var hud = $CanvasLayer/HUD
@onready var resultado = $CanvasLayer/Resultado
@onready var recompensa_ui = $CanvasLayer/Recompensa
@onready var recompensa_titulo = $CanvasLayer/Recompensa/Titulo

@onready var arena = $Arena
@onready var player = $Arena/player_diluc
@onready var camera: Camera2D = $Arena/player_diluc/Camera2D
@onready var inimigos_container = $Arena/Inimigos
@onready var spawn_points = $Arena/SpawnPoints.get_children()

@onready var resultado_titulo = $CanvasLayer/Resultado/Titulo
@onready var resultado_pontuacao = $CanvasLayer/Resultado/Pontuacao
@onready var resultado_onda = $CanvasLayer/Resultado/Onda
@onready var resultado_inimigos = $CanvasLayer/Resultado/InimigosDerrotados
@onready var botao_continuar = $CanvasLayer/Resultado/BotaoContinuar

@onready var hud_onda = $CanvasLayer/HUD/Onda
@onready var hud_inimigos = $CanvasLayer/HUD/Inimigos
@onready var hud_pontuacao = $CanvasLayer/HUD/Pontuacao
@onready var hud_barra_vida = $CanvasLayer/HUD/BarraVida

# Os 3 áudios ficam soltos direto no Diluc_minigame (não dentro do CanvasLayer)
@onready var musica_menu: AudioStreamPlayer = $MenuSondTrack
@onready var musica_jogo: AudioStreamPlayer = $Soundtrack
@onready var musica_recompensa: AudioStreamPlayer = $Recompensa

var recompensa_1
var recompensa_2
var recompensa_3

var tween_titulo_recompensa: Tween


func _ready():

	menu.visible = true
	hud.visible = false
	resultado.visible = false
	recompensa_ui.visible = false

	botao_jogar.pressed.connect(iniciar_jogo)
	botao_sair.pressed.connect(sair_do_minigame)
	botao_continuar.pressed.connect(sair_do_minigame)

	player.tomou_dano.connect(_on_player_tomou_dano)
	player.morreu.connect(_on_player_morreu)

	$CanvasLayer/Recompensa/Opcao1.pressed.connect(func(): escolher_recompensa(recompensa_1))
	$CanvasLayer/Recompensa/Opcao2.pressed.connect(func(): escolher_recompensa(recompensa_2))
	$CanvasLayer/Recompensa/Opcao3.pressed.connect(func(): escolher_recompensa(recompensa_3))

	tocar_musica_menu()
	atualizar_hud()


func abrir():

	estado_atual = Estado.MENU

	camera.enabled = true
	camera.make_current()

	menu.visible = true
	background.visible = true
	hud.visible = false
	resultado.visible = false
	recompensa_ui.visible = false

	onda_atual = 1
	inimigos_para_matar = 0
	inimigos_mortos = 0
	mudando_onda = false
	pontuacao = 0

	atualizar_hud()
	tocar_musica_menu()


func iniciar_jogo():

	print("PARTIDA INICIADA")

	tocar_musica_jogo()

	limpar_inimigos()

	player.resetar_status()

	estado_atual = Estado.JOGO

	background.visible = false
	menu.visible = false
	hud.visible = true
	resultado.visible = false

	onda_atual = 1
	inimigos_mortos = 0
	inimigos_para_matar = 0
	pontuacao = 0
	mudando_onda = false

	atualizar_hud()

	iniciar_onda()


func iniciar_onda():

	inimigos_mortos = 0

	var composicao := criar_composicao_onda()
	inimigos_para_matar = composicao.size()

	atualizar_hud()

	print("ONDA ", onda_atual, " | INIMIGOS: ", inimigos_para_matar)

	for tipo in composicao:

		if estado_atual != Estado.JOGO:
			return

		if player.morto:
			return

		spawnar_inimigo(tipo)

		await get_tree().create_timer(calcular_intervalo_spawn()).timeout


func spawnar_inimigo(tipo_inimigo):

	if inimigo_scene == null:
		print("ERRO: inimigo_scene não configurado!")
		return

	var ponto = escolher_spawn_point()
	if ponto == null:
		print("ERRO: não encontrou SpawnPoint!")
		return

	var inimigo = inimigo_scene.instantiate()

	# IMPORTANTE: configurar tipo e jogador ANTES de add_child(),
	# assim _ready() do inimigo já lê os valores corretos e evita
	# reconfiguração duplicada / busca por grupo.
	inimigo.tipo = tipo_inimigo
	inimigo.jogador = player

	inimigos_container.add_child(inimigo)
	
	inimigo.tocar_som_spawn()

	inimigo.global_position = ponto.global_position

	inimigo.aplicar_escalonamento(onda_atual)
	
	if inimigo.has_signal("morreu"):
		inimigo.morreu.connect(_on_inimigo_morreu)

	print("INIMIGO SPAWNADO: | Tipo: ", inimigo.get_tipo_nome())


func _on_inimigo_morreu(inimigo):

	inimigos_mortos += 1
	pontuacao += inimigo.get_pontuacao()

	atualizar_hud()

	if inimigos_mortos >= inimigos_para_matar and not mudando_onda:
		mudando_onda = true
		proxima_onda()


func proxima_onda():

	onda_atual += 1
	atualizar_hud()

	await get_tree().create_timer(2.0).timeout

	# Recompensa a cada 3 ondas
	if (onda_atual - 1) % 2 == 0:
		mostrar_recompensas()
		return

	mudando_onda = false
	iniciar_onda()


func atualizar_hud():

	hud_onda.text = "Onda: " + str(onda_atual)
	hud_inimigos.text = "Derrotados: %d/%d" % [inimigos_mortos, inimigos_para_matar]
	hud_pontuacao.text = "Pontos: " + str(pontuacao)
	hud_barra_vida.max_value = player.vida_maxima
	hud_barra_vida.value = player.vida


func sair_do_minigame():
	emit_signal("closed")


func _on_player_tomou_dano():
	atualizar_hud()


func _on_player_morreu():

	estado_atual = Estado.RESULTADO

	hud.visible = false
	recompensa_ui.visible = false
	resultado.visible = true

	parar_todas_as_musicas()
	musica_menu.play()

	resultado_titulo.text = "FIM DE JOGO"
	resultado_pontuacao.text = "Pontuação: " + str(pontuacao)
	resultado_onda.text = "Onda alcançada: " + str(onda_atual)
	resultado_inimigos.text = "Inimigos derrotados: " + str(inimigos_mortos)


func limpar_inimigos():
	for inimigo in inimigos_container.get_children():
		inimigo.queue_free()


func criar_composicao_onda() -> Array:

	var composicao: Array = []

	var quantidade_normal := 5 + int((onda_atual - 1) * 1.2)
	quantidade_normal = min(quantidade_normal, 18)
	for i in quantidade_normal:
		composicao.append(TipoInimigo.NORMAL)

	if onda_atual >= 3:
		var quantidade_rapidos := 1 + int((onda_atual - 3) / 3)
		quantidade_rapidos = min(quantidade_rapidos, 5)
		for i in quantidade_rapidos:
			composicao.append(TipoInimigo.RAPIDO)

	if onda_atual >= 5:
		var quantidade_tanques := 1 + int((onda_atual - 5) / 4)
		quantidade_tanques = min(quantidade_tanques, 3)
		for i in quantidade_tanques:
			composicao.append(TipoInimigo.TANQUE)

	if onda_atual >= 10 and onda_atual % 5 == 0:
		composicao.append(TipoInimigo.BOSS)

	composicao.shuffle()
	return composicao


func escolher_spawn_point() -> Node2D:

	if spawn_points.is_empty():
		print("ERRO: nenhum SpawnPoint!")
		return null

	var pontos_validos: Array[Node2D] = []

	for ponto in spawn_points:
		if not is_instance_valid(ponto):
			continue
		var distancia: float = ponto.global_position.distance_to(player.global_position)
		if distancia >= distancia_minima_spawn:
			pontos_validos.append(ponto)

	if pontos_validos.is_empty():
		return spawn_points.pick_random()

	return pontos_validos.pick_random()


func calcular_intervalo_spawn() -> float:

	var intervalo: float = intervalo_spawn_inicial - ((onda_atual - 1) * 0.015)
	return clamp(intervalo, intervalo_spawn_minimo, intervalo_spawn_inicial)


func gerar_recompensas():

	var opcoes = [
		TipoRecompensa.DANO,
		TipoRecompensa.VIDA,
		TipoRecompensa.VIDA_MAXIMA,
		TipoRecompensa.VELOCIDADE,
		TipoRecompensa.KNOCKBACK
	]

	opcoes.shuffle()

	recompensa_1 = opcoes[0]
	recompensa_2 = opcoes[1]
	recompensa_3 = opcoes[2]

	configurar_botao_recompensa($CanvasLayer/Recompensa/Opcao1, recompensa_1)
	configurar_botao_recompensa($CanvasLayer/Recompensa/Opcao2, recompensa_2)
	configurar_botao_recompensa($CanvasLayer/Recompensa/Opcao3, recompensa_3)


func configurar_botao_recompensa(botao: Button, tipo: TipoRecompensa):

	match tipo:
		TipoRecompensa.DANO:
			botao.text = "⚔️\n+5 DANO"
		TipoRecompensa.VIDA:
			botao.text = "❤️\n+30 VIDA"
		TipoRecompensa.VIDA_MAXIMA:
			botao.text = "💚\n+20 VIDA MÁXIMA"
		TipoRecompensa.VELOCIDADE:
			botao.text = "💨\n+10 VELOCIDADE"
		TipoRecompensa.KNOCKBACK:
			botao.text = "🌀\n+30 KNOCKBACK"


func aplicar_recompensa(tipo: TipoRecompensa):

	match tipo:
		TipoRecompensa.DANO:
			player.aumentar_dano(5)
		TipoRecompensa.VIDA:
			player.recuperar_vida(30)
		TipoRecompensa.VIDA_MAXIMA:
			player.aumentar_vida_maxima(20)
		TipoRecompensa.VELOCIDADE:
			player.aumentar_velocidade(10)
		TipoRecompensa.KNOCKBACK:
			player.aumentar_knockback(30)


func escolher_recompensa(tipo: TipoRecompensa):

	aplicar_recompensa(tipo)

	if tween_titulo_recompensa:
		tween_titulo_recompensa.kill()

	recompensa_titulo.modulate = Color.WHITE
	recompensa_titulo.scale = Vector2.ONE

	recompensa_ui.visible = false
	hud.visible = true

	mudando_onda = false

	tocar_musica_jogo()
	atualizar_hud()
	iniciar_onda()


func mostrar_recompensas():

	mudando_onda = true
	hud.visible = false
	recompensa_ui.visible = true

	tocar_musica_recompensa()
	gerar_recompensas()
	animar_titulo_recompensa()


func parar_todas_as_musicas():
	musica_menu.stop()
	musica_jogo.stop()
	musica_recompensa.stop()


func tocar_musica_menu():
	parar_todas_as_musicas()
	if not musica_menu.playing:
		musica_menu.play()


func tocar_musica_jogo():
	parar_todas_as_musicas()
	if not musica_jogo.playing:
		musica_jogo.play()


func tocar_musica_recompensa():
	parar_todas_as_musicas()
	if not musica_recompensa.playing:
		musica_recompensa.play()


func animar_titulo_recompensa():

	if tween_titulo_recompensa:
		tween_titulo_recompensa.kill()

	recompensa_titulo.modulate = Color.WHITE
	recompensa_titulo.scale = Vector2.ONE

	tween_titulo_recompensa = create_tween()
	tween_titulo_recompensa.set_loops()

	var cores := [
		Color(1.0, 0.2, 0.2),
		Color(1.0, 0.8, 0.1),
		Color(0.3, 1.0, 0.4),
		Color(0.3, 0.7, 1.0),
		Color(0.8, 0.3, 1.0),
	]

	for cor in cores:
		tween_titulo_recompensa.tween_property(recompensa_titulo, "modulate", cor, 0.10)
		tween_titulo_recompensa.parallel().tween_property(recompensa_titulo, "scale", Vector2(1.08, 1.08), 0.10)
		tween_titulo_recompensa.tween_property(recompensa_titulo, "scale", Vector2.ONE, 0.10)
