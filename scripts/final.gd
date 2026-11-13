extends Node2D


enum Estado {
	ESCURIDAO,
	PARABENS,
	CARTA,
	LIVRE
}


var estado_atual := Estado.ESCURIDAO


func _ready():

	# =========================
	# ESTADO INICIAL
	# =========================

	$Escuridao.color = Color("#05000A")

	# Lâmpada começa desligada
	$lampada/PointLight2D.enabled = false

	# Carta começa escondida
	$Carta.hide()

	# Bolo e Eve começam bloqueados
	$ObjetosInterativos/ObjetoInterativoBolo.ativar(false)
	$ObjetosInterativos/ObjetoInterativoEve.ativar(false)

	# Conecta vela
	$Vela.vela_apagada.connect(_on_vela_apagada)

	# Conecta carta
	$Carta.carta_finalizada.connect(_on_carta_finalizada)


func _on_vela_apagada():

	if estado_atual != Estado.ESCURIDAO:
		return

	estado_atual = Estado.PARABENS

	# =========================
	# ILUMINAÇÃO
	# =========================
	

	var tween = create_tween()

	# Apaga a luz da vela
	tween.tween_property(
		$LuzVela,
		"energy",
		0.0,
		0.5
	)
	$Confete.play()

	# Remove a escuridão
	tween.parallel().tween_property(
		$Escuridao,
		"color",
		Color.WHITE,
		0.8
	)

	await tween.finished

	# Começa os parabéns
	iniciar_dialogo_parabens()


func iniciar_dialogo_parabens():

	var dialogos = [
		{
			"name": "Nik",
			"text": "SUPRREESSAA!!!",
			"text_color":Color(1.498, 0.0, 1.239, 1.0),
			"bg_color": Color(0, 0, 0, 0.8),
			"border_color": Color(0.0, 0.985, 1.266, 1.0),
			"animation": "Nik", 
			"side": Side.SIDE_RIGHT
		},
		{
			"name": "Mamae",
			"text": "BOLO DO CREEPER!",
			"text_color": Color(0.0, 0.632, 0.451, 1.0),
			"bg_color": Color(0, 0, 0, 0.8),
			"border_color": Color(1.643, 0.551, 0.0, 1.0),
			"animation": "Mamae", 
			"side": Side.SIDE_RIGHT
		},
		{
			"name": "Eddw",
			"text": "DIA DO BOLO!!",
			"text_color": Color(0.0, 0.655, 0.0, 1.0),
			"bg_color": Color(0, 0, 0, 0.8),
			"border_color": Color(1.643, 0.0, 0.0, 1.0),
			"animation": "Eddw", 
			"side": Side.SIDE_RIGHT
		},
		{
			"name": "Joao",
			"text": "DAMNN!!",
			"text_color": Color(0.308, 0.493, 1.0, 1.0),
			"bg_color": Color(0, 0, 0, 0.8),
			"border_color": Color(0.576, 0.0, 1.546, 1.0),
			"animation": "Joao", 
			"side": Side.SIDE_RIGHT
		},
		{
			"name": "Kath",
			"text": "Eu vo chorar... ",
			"text_color": Color(1, 0, 0),
			"bg_color": Color(0, 0, 0, 0.8),
			"border_color": Color(0.0, 1.643, 0.339, 1.0),
			"animation": "Kath", 
			"side": Side.SIDE_LEFT
		},
		{
			"name": "Eddw",
			"text": "Come o Bolo do creeper!",
			"text_color": Color(0.0, 0.655, 0.0, 1.0),
			"bg_color": Color(0, 0, 0, 0.8),
			"border_color": Color(1.643, 0.0, 0.0, 1.0),
			"animation": "Eddw", 
			"side": Side.SIDE_RIGHT
		},
		{
			"name": "Mamae",
			"text": "Primeiro pedaço é meu ein...",
			"text_color": Color(0.0, 1.0, 0.0, 1.0),
			"bg_color": Color(0, 0, 0, 0.8),
			"border_color": Color(1.643, 1.643, 0.0, 1.0),
			"animation": "Mamae", 
			"side": Side.SIDE_RIGHT
		},
		{
			"name": "Kath",
			"text": "ATA",
			"text_color": Color(1, 0, 0),
			"bg_color": Color(0, 0, 0, 0.8),
			"border_color": Color(0.0, 1.643, 0.339, 1.0),
			"animation": "Kath", 
			"side": Side.SIDE_LEFT
		},
	]

	$dialog_box.start_dialog(dialogos)

	# Espera todos os diálogos
	await $dialog_box.dialog_finished

	# Agora começa a cena da carta
	mostrar_carta()


func mostrar_carta():

	estado_atual = Estado.CARTA

	$Carta.mostrar_carta()


func _on_carta_finalizada():

	# Carta terminou
	# Agora liga a lâmpada

	ligar_lampada()

	# Libera exploração
	liberar_exploracao()


func ligar_lampada():

	$lampada/PointLight2D.enabled = true

	$lampada/PointLight2D.energy = 0.0

	var tween = create_tween()

	tween.tween_property(
		$lampada/PointLight2D,
		"energy",
		1.0,
		0.8
	)


func liberar_exploracao():

	estado_atual = Estado.LIVRE
	
	$SoundTrack.play()

	$ObjetosInterativos/ObjetoInterativoBolo.ativar(true)

	$ObjetosInterativos/ObjetoInterativoEve.ativar(true)
