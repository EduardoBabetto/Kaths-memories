extends Node2D

signal vela_apagada

@onready var sprite = $AnimatedSprite2D
@onready var audio_queimando = $Queimando
@onready var audio_apagado = $Apagado

var pode_apagar := true


func _ready():
	audio_queimando.play()
	sprite.play("fogo")


func apagar_vela():

	if not pode_apagar:
		return

	pode_apagar = false

	# Toca a animação de apagar uma única vez
	audio_queimando.stop()
	audio_apagado.play()
	sprite.play("apagar")

	# Espera a animação terminar
	await sprite.animation_finished

	# Para a animação
	sprite.stop()

	# Mantém no último frame
	sprite.frame = sprite.sprite_frames.get_frame_count("apagar") - 1

	# Avisa a fase
	vela_apagada.emit()
