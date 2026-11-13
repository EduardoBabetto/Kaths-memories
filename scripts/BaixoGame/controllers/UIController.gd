extends Node
class_name UIController

signal start_pressed
signal quit_pressed

# =========================
# MENU
# =========================

@export var menu: Node
@export var game: Node
@export var vitoria: Node
@export var game_over: Node

var main

func initialize(main_node):

	main = main_node

	menu = main.get_node("CanvasLayer/Menu/CanvasLayer")

	game = main.get_node("CanvasLayer/Game")

	start_btn = main.get_node("CanvasLayer/Menu/CanvasLayer/HBoxContainer/VBoxContainer/Start_btn")

	quit_btn = main.get_node("CanvasLayer/Menu/CanvasLayer/HBoxContainer/VBoxContainer/Quit_Btn")

	score_label = main.get_node("CanvasLayer/Game/Score")

	combo_label = main.get_node("CanvasLayer/Game/Combo")

	vidas = [
		main.get_node("CanvasLayer/Game/vidas/vida"),
		main.get_node("CanvasLayer/Game/vidas/vida2"),
		main.get_node("CanvasLayer/Game/vidas/vida3")
	]
	
	vitoria = null
	game_over = null

	setup()

var start_btn : Button

var quit_btn : Button

# =========================
# SCORE
# =========================

@export var score_label: RichTextLabel
@export var combo_label: RichTextLabel

# =========================
# VIDAS
# =========================

var vidas = []

func setup():

	if !start_btn.pressed.is_connected(_on_start_pressed):
		start_btn.pressed.connect(_on_start_pressed)

	if !quit_btn.pressed.is_connected(_on_quit_pressed):
		quit_btn.pressed.connect(_on_quit_pressed)

func _on_start_pressed():
	emit_signal("start_pressed")

func _on_quit_pressed():
	emit_signal("quit_pressed")
	
func atualizar_score(score, multiplicador):

	score_label.text = str(score) + " pts"

	combo_label.text = str(multiplicador) + "X"
	
func mostrar_menu():

	menu.show()
	game.hide()

	if vitoria:
		vitoria.hide()

	if game_over:
		game_over.hide()

func esconder_menu():

	menu.hide()

func atualizar_vidas(vida_hits):

	match vida_hits:

		6:
			vidas[0].frame = 0
			vidas[1].frame = 0
			vidas[2].frame = 0

		5:
			vidas[2].frame = 1

		4:
			vidas[2].frame = 2

		3:
			vidas[1].frame = 1

		2:
			vidas[1].frame = 2

		1:
			vidas[0].frame = 1

		0:
			vidas[0].frame = 2

		_:
			resetar_vidas()
		
func resetar_vidas():

	for vida in vidas:

		vida.frame = 0
	
func mostrar_vitoria():

	menu.hide()
	game.hide()

	if game_over:
		game_over.hide()

	if vitoria:
		vitoria.show()

func mostrar_game_over():

	menu.hide()
	game.hide()

	if vitoria:
		vitoria.hide()

	if game_over:
		game_over.show()
	
func mostrar_jogo():

	menu.hide()
	game.show()

	
func resetar():

	atualizar_score(0, 1)

	resetar_vidas()

	mostrar_jogo()
