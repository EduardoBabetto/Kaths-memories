extends Area2D

@export var next_level = ""
var is_inside: bool = false

func _on_body_entered(body: Node2D) -> void:
			is_inside = true

func _on_body_exited(body: Node2D) -> void:
			is_inside = false

func _process(delta: float) -> void:
		if is_inside and Input.is_action_just_pressed("interact"):
			call_deferred("load_next_scene")

func load_next_scene():
	Loading.change_scene_with_loading("res://scenes/rooms/"+next_level+".tscn")
