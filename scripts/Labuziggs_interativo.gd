extends Node2D
signal dialog_finished

@export var dialog_data = [
		{
		"name": "Kath",
		"text": "PAVIO QUEIMANDO!",
		"text_color": Color(1, 0, 0),
		"bg_color": Color(0, 0, 0, 0.8),
		"border_color": Color(0.0, 1.643, 0.339, 1.0),
		"animation": "Kath",
		"side": Side.SIDE_RIGHT
	},
		{
		"name": "Kath",
		"text": "Tragam a grandona!",
		"text_color": Color(1, 0, 0),
		"bg_color": Color(0, 0, 0, 0.8),
		"border_color": Color(0.0, 1.643, 0.339, 1.0),
		"animation": "Kath",
		"side": Side.SIDE_RIGHT
	},
		{
		"name": "Kath",
		"text": "Quer aprender a desarmar uma bomba?",
		"text_color": Color(1, 0, 0),
		"bg_color": Color(0, 0, 0, 0.8),
		"border_color": Color(0.0, 1.643, 0.339, 1.0),
		"animation": "Kath",
		"side": Side.SIDE_RIGHT
	},
		{
		"name": "Kath",
		"text": "Alguém...",
		"text_color": Color(1, 0, 0),
		"bg_color": Color(0, 0, 0, 0.8),
		"border_color": Color(0.0, 1.643, 0.339, 1.0),
		"animation": "Kath",
		"side": Side.SIDE_RIGHT
	},
]

var player_inside = false
@onready var interact_icon = $AnimatedSprite2D
var time := 0.0
@onready var dialog_box = get_tree().get_first_node_in_group("dialog")

func _ready():
	interact_icon.hide()

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
	
	if player_inside and Input.is_action_just_pressed("interact"):
		if not dialog_box.is_active and not dialog_box.input_locked:
			dialog_box.start_dialog(dialog_data)
			interact_icon.hide()
			emit_signal("dialog_finished")
