extends Node2D

@export var dialog_data = [
	{
		"name": "Kath",
		"text": "Meu baixo...",
		"text_color": Color(1, 0, 0),
		"bg_color": Color(0, 0, 0, 0.8),
		"border_color": Color(0.0, 1.643, 0.339, 1.0),
		"animation": "Kath",
		"side": Side.SIDE_RIGHT
	},
	{
		"name": "Kath",
		"text": "ELE É MUITO FODA!",
		"text_color": Color(1, 0, 0),
		"bg_color": Color(0, 0, 0, 0.8),
		"border_color": Color(0.0, 1.643, 0.339, 1.0),
		"animation": "Kath",
		"side": Side.SIDE_RIGHT
	},
	{
		"name": "Kath",
		"text": "Se liga nesse solo!!",
		"text_color": Color(1, 0, 0),
		"bg_color": Color(0, 0, 0, 0.8),
		"border_color": Color(0.0, 1.643, 0.339, 1.0),
		"animation": "Kath",
		"side": Side.SIDE_RIGHT
	},
]

@export var minigame_scene : PackedScene

var player_inside := false
var time := 0.0
var esperando_dialogo := false

@onready var interact_icon = %AnimatedSprite2D
@onready var dialog_box = get_tree().get_first_node_in_group("dialog")
@export var manager: Node


func _ready():

	interact_icon.hide()
		
	dialog_box.dialog_finished.connect(_on_dialog_finished)
	

func _process(delta):

	time += delta

	interact_icon.position.y = -40 + sin(time*3)*5

	if player_inside \
	and Input.is_action_just_pressed("interact") \
	and !dialog_box.is_active \
	and !dialog_box.input_locked:

		esperando_dialogo = true

		dialog_box.start_dialog(dialog_data)

		interact_icon.hide()


func _on_dialog_finished():

	if !esperando_dialogo:
		return

	esperando_dialogo = false

	if player_inside:
		
		manager.open(minigame_scene)


func _on_area_2d_body_entered(body):

	if body.is_in_group("player"):

		player_inside = true

		interact_icon.show()


func _on_area_2d_body_exited(body):

	if body.is_in_group("player"):

		player_inside = false

		interact_icon.hide()
