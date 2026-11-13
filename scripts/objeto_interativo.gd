extends Node2D

@export var dialog_data = [
]

var player_inside = false
@onready var interact_icon = %AnimatedSprite2D
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
