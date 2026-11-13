extends Node2D

@onready var anim_sprite = $AnimatedSprite2D
@onready var press_text = $RichTextLabel
@onready var fade_rect = $CanvasLayer/FadeRect
@onready var ronco = $Ronco

var can_press = false

func _ready():
	press_text.visible = false
	
	fade_rect.color = Color.BLACK
	fade_rect.modulate.a = 0.0
	
	start_cutscene()

func start_cutscene():
	ronco.play()
	anim_sprite.play("Dormindo")
	await get_tree().create_timer(5.0).timeout
	
	show_press_text()

func show_press_text():
	press_text.visible = true
	can_press = true
	start_text_effect()

func start_text_effect():
	var tween = create_tween()
	tween.set_loops()
	
	tween.tween_property(press_text, "modulate:a", 0.0, 0.8)
	tween.tween_property(press_text, "modulate:a", 1.0, 0.8)

func _input(event):
	if can_press and event.is_pressed():
		start_wakeup()

func start_wakeup():
	ronco.stop()
	can_press = false
	press_text.visible = false
	
	anim_sprite.play("Acordado")
	await anim_sprite.animation_finished
	
	start_fade()
	
func start_fade():
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, 2)
	
	await tween.finished
	
	change_scene()

func change_scene():
	get_tree().change_scene_to_file("res://scenes/rooms/main.tscn")
