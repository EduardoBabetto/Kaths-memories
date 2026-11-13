extends Node2D


@export var dialog_data = [
	{
		"name": "Kath",
		"text": "MINHA ESPADA DO DILUC!",
		"text_color": Color(1, 0, 0),
		"bg_color": Color(0, 0, 0, 0.8),
		"border_color": Color(0.0, 1.643, 0.339, 1.0),
		"animation": "Kath",
		"side": Side.SIDE_RIGHT
	},
	{
		"name": "Kath",
		"text": "Faz tempo que não uso ela,",
		"text_color": Color(1, 0, 0),
		"bg_color": Color(0, 0, 0, 0.8),
		"border_color": Color(0.0, 1.643, 0.339, 1.0),
		"animation": "Kath",
		"side": Side.SIDE_RIGHT
	},
	{
		"name": "Kath",
		"text": "Vo bater em uns...",
		"text_color": Color(1, 0, 0),
		"bg_color": Color(0, 0, 0, 0.8),
		"border_color": Color(0.0, 1.643, 0.339, 1.0),
		"animation": "Kath",
		"side": Side.SIDE_RIGHT
	},
	{
		"name": "Kath",
		"text": "fANTAMAS BOBÕES!",
		"text_color": Color(1, 0, 0),
		"bg_color": Color(0, 0, 0, 0.8),
		"border_color": Color(0.0, 1.643, 0.339, 1.0),
		"animation": "Kath",
		"side": Side.SIDE_RIGHT
	},
]


@export var minigame_scene: PackedScene


var player_inside = false
var time := 0.0

var esperando_dialogo := false
@onready var interact_icon = %AnimatedSprite2D
@onready var dialog_box = get_tree().get_first_node_in_group("dialog")
@export var manager: Node


func _ready():

	interact_icon.hide()

	dialog_box.dialog_finished.connect(_on_dialog_finished)


func _on_dialog_finished():

	iniciar_minigame()


func iniciar_minigame():
	
	if !esperando_dialogo:
		return
		
	esperando_dialogo = false
	
	if manager:
		manager.open(minigame_scene)
	else:
		print("ERRO: MinigameManager não encontrado!")


func _on_area_2d_body_entered(body):

	if body.is_in_group("player"):

		player_inside = true
		interact_icon.show()


func _on_area_2d_body_exited(body):

	if body.is_in_group("player"):

		player_inside = false
		interact_icon.hide()


func _process(delta):

	time += delta

	interact_icon.position.y = -40 + sin(time * 3) * 5

	if player_inside \
	and Input.is_action_just_pressed("interact") \
	and !dialog_box.is_active \
	and !dialog_box.input_locked:

		esperando_dialogo = true

		dialog_box.start_dialog(dialog_data)

		interact_icon.hide()
