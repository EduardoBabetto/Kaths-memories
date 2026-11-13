extends Node2D

@onready var anim = $AnimatedSprite2D
@onready var audio1 = $Shaco
@onready var audio2 = $Musica

func play_jumpscare():
	audio2.play()
	anim.play("default")

func stop():
	audio2.stop()
	audio1.play()
