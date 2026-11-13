extends Node2D

@export var dialog_data = [
	{
		"name": "Shaco Box",
		"text": "Porque está tão sério?",
		"text_color": Color(1, 0, 0),
		"bg_color": Color(0, 0, 0, 0.8),
		"border_color": Color(0.0, 1.643, 0.339, 1.0),
		"animation": "ShacoBox",
		"side": Side.SIDE_LEFT
	},
	{
		"name": "Kath",
		"text": "Me caguei.",
		"text_color": Color(1, 0, 0),
		"bg_color": Color(0, 0, 0, 0.8),
		"border_color": Color(0.0, 1.643, 0.339, 1.0),
		"animation": "Kath",
		"side": Side.SIDE_RIGHT
	},
	
]

var player_inside = false
var activated = false

@onready var interact_icon = %AnimatedSprite2D
@onready var dialog_box = get_tree().get_first_node_in_group("dialog")
@onready var shaco_anim = $"/root/Memories/ShacoBox"

var time := 0.0

func _ready():
	interact_icon.hide()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player") and not activated:
		player_inside = true
		interact_icon.show()

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		player_inside = false
		interact_icon.hide()

func _process(delta):
	time += delta
	interact_icon.position.y = -40 + sin(time * 3) * 5

	if player_inside and Input.is_action_just_pressed("interact"):
		if not dialog_box.is_active and not dialog_box.input_locked and not activated:
			activate()

func activate():
	activated = true
	
	interact_icon.hide()
	# inicia diálogo
	dialog_box.start_dialog(dialog_data)
	# espera o diálogo começar
	await get_tree().create_timer(1.5).timeout
	# toca animaçãod
	shaco_anim.play_jumpscare()
	
	await get_tree().create_timer(1.0).timeout
	
	shaco_anim.stop()
