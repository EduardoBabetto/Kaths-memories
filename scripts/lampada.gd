extends Node2D

@onready var light = $PointLight2D
var time := 0.0

func _process(delta):
	time += delta
	light.energy = 1.2 + sin(time * 10) * 0.2

func toggle():
	light.enabled = not light.enabled

func turn_on():
	light.enabled = true

func turn_off():
	light.enabled = false
		
func _on_interruptor_toggled():
	toggle()
