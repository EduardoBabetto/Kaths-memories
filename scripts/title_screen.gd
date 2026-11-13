extends Control

@onready var sd = $SoundTrack
@onready var controles = $Controles/CanvasLayer

var can_press = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sd.play()
	controles.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if can_press and event.is_pressed():
		controles.hide()

func _on_start_btn_pressed() -> void:
	Loading.change_scene_with_loading("res://scenes/rooms/dormindo.tscn")


func _on_credits_btn_pressed() -> void:
	controles.show()
	await get_tree().create_timer(3.0).timeout
	can_press = true

func _on_quit_btn_pressed() -> void:
	get_tree().quit()
