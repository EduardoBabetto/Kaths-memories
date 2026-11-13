extends Node2D

@export var lampada: Node
signal toggled

@onready var audio = $Audio

var player_inside = false

func _ready():
	if lampada:
		connect("toggled", Callable(lampada, "_on_interruptor_toggled"))
	else:
		print("Lampada não atribuída!")

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player_inside = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		player_inside = false

func _process(delta):
	if player_inside and Input.is_action_just_pressed("interact"):
		audio.play()
		emit_signal("toggled")
