extends Node2D

@onready var eve = $AnimatedSprite2D
@onready var audio = $Miado

@export var player: Node


func interagir():

	# Animação da Eve
	eve.play("carinho")
	audio.play()

	# Aqui vamos chamar a animação do Eduardo
	# depois de vermos o script dele.

	await eve.animation_finished

	eve.play("default")
