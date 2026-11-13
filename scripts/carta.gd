extends CanvasLayer


signal carta_finalizada


@onready var fundo = $ColorRect
@onready var carta = $AnimatedSprite2D
@onready var fundo_carta=$AnimatedSprite2D/ColorRect
@onready var texto_carta = $AnimatedSprite2D/RichTextLabel2
@onready var texto_abrir = $RichTextLabel
@onready var player = get_tree().get_first_node_in_group("player")
@onready var audio = $Carta

var carta_ativa := false
var pode_interagir := false
var carta_aberta := false
var animando := false

var texto_carta_conteudo := """
FELIZ ANIVERSÁRIO!

Kath, isso é seu presente de
aniversário! Muito esforço foi colocado
aqui, guarde isso com carinho e entre
sempre que precisar. Te amo garota, você
é incrível e maravilhosa, não tenha medo
de ser feliz!

                  - presente de EDDW
"""


func _ready():

	# A carta começa completamente escondida
	hide()
	fundo_carta.hide()

	# Garante que começa no primeiro frame
	carta.stop()
	carta.frame = 0

	# Texto vermelho começa escondido
	texto_carta.hide()

	# Texto "Aperte qualquer botão" começa escondido
	texto_abrir.hide()

	# Conteúdo do texto
	texto_carta.text = texto_carta_conteudo


func mostrar_carta():

	print("CARTA: mostrar_carta()")

	if carta_ativa:
		return

	carta_ativa = true
	pode_interagir = false
	carta_aberta = false
	animando = false

	# =========================
	# BLOQUEIA O PLAYER
	# =========================

	if player:
		player.can_move = false

	# =========================
	# RESET
	# =========================

	carta.stop()
	carta.animation = "abrindo"
	carta.frame = 0

	texto_carta.visible = false
	texto_abrir.visible = false

	fundo.visible = true
	carta.visible = true

	fundo.modulate.a = 1.0
	carta.modulate.a = 1.0
	texto_carta.modulate.a = 1.0
	texto_abrir.modulate.a = 1.0

	visible = true

	print("CARTA: CanvasLayer visível")

	await get_tree().create_timer(2.0).timeout

	if not carta_ativa:
		return

	print("CARTA: mostrando instrução")

	mostrar_instrucao()

func mostrar_instrucao():

	texto_abrir.show()

	# Começa transparente
	texto_abrir.modulate.a = 0.0

	# Cria efeito de aparecer/desaparecer
	var tween = create_tween()

	tween.set_loops()

	tween.tween_property(
		texto_abrir,
		"modulate:a",
		1.0,
		0.7
	)

	tween.tween_property(
		texto_abrir,
		"modulate:a",
		0.0,
		0.7
	)

	pode_interagir = true


func _input(event):

	if not carta_ativa:
		return

	if not pode_interagir:
		return


	# =========================
	# TECLADO
	# =========================

	if event is InputEventKey:

		if not event.pressed:
			return

		if event.echo:
			return


		# --------------------------------
		# CARTA FECHADA
		# Qualquer tecla abre
		# --------------------------------

		if not carta_aberta:

			processar_botao()

			get_viewport().set_input_as_handled()

			return


		# --------------------------------
		# CARTA ABERTA
		# SOMENTE SPACE FINALIZA
		# --------------------------------

		if event.keycode == KEY_SPACE:

			processar_botao()

			get_viewport().set_input_as_handled()

			return

func processar_botao():

	if animando:
		return


	# =========================
	# PRIMEIRA INTERAÇÃO
	# =========================
	# Abre a carta

	if not carta_aberta:

		abrir_carta()

		return


	# =========================
	# SEGUNDA INTERAÇÃO
	# =========================
	# Somente SPACE chega aqui

	finalizar_carta()


func abrir_carta():

	print("CARTA: abrindo")
	audio.play()
	animando = true
	pode_interagir = false

	# Esconde o texto de instrução
	texto_abrir.visible = false

	# Reset
	carta.stop()
	carta.animation = "abrindo"
	carta.frame = 0

	# Toca animação
	carta.play("abrindo")

	# Espera terminar
	await carta.animation_finished

	# Garante último frame
	carta.stop()
	carta.frame = 9

	print("CARTA: animação terminou")

	carta_aberta = true
	animando = false

	# Mostra texto vermelho
	mostrar_texto_carta()


func mostrar_texto_carta():
	fundo_carta.show()
	texto_carta.show()

	# Começa invisível
	texto_carta.visible_characters = 0

	# Escreve o texto
	while texto_carta.visible_characters < texto_carta.get_total_character_count():

		texto_carta.visible_characters += 1

		await get_tree().create_timer(0.025).timeout

	# Depois que terminou de escrever,
	# podemos interagir novamente
	pode_interagir = true


func finalizar_carta():

	print("CARTA: finalizando")

	pode_interagir = false
	carta_ativa = false

	# =========================
	# LIBERA O PLAYER
	# =========================

	if player:
		player.can_move = true

	# =========================
	# ESCONDE CARTA
	# =========================

	visible = false

	# Reset
	carta.stop()
	carta.frame = 0

	texto_carta.visible = false
	texto_abrir.visible = false

	# Avisa o Final.gd
	carta_finalizada.emit()
