extends Node

@onready var player = $"../AudioStreamPlayer"

func play(path):

	player.stream = load(path)

	player.play()

func stop():

	player.stop()

func get_time():

	return player.get_playback_position()
