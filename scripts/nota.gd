extends Area2D

@export var speed := 400.0

var can_hit := false

@onready var sprite = $Sprite2D

func _ready():
	randomize()

	# Escolhe sprite aleatório entre 3
	var random_note = randi() % 3

	match random_note:
		0:
			sprite.frame = 0
		1:
			sprite.frame = 1
		2:
			sprite.frame = 2

func _process(delta):
	position.y += speed * delta

	# destruir se sair da tela
	if position.y > 900:
		queue_free()

func _on_hitbox_body_entered(body):
	can_hit = true

func _on_hitbox_body_exited(body):
	can_hit = false
