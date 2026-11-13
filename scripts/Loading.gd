extends CanvasLayer

@onready var fade_rect = $FadeRect
@onready var loading_text = $LoadingText
@onready var animated_sprite2d = $AnimatedSprite2D

var tween
var loading_active = false

func _ready():
	fade_rect.color.a = 0

func fade_out():
	loading_active = true
	loading_text.visible = true
	animated_sprite2d.visible = true
	
	animate_loading_text()
	
	tween = create_tween()
	tween.tween_property(fade_rect, "color:a", 1.0, 0.5)
	await tween.finished

func fade_in():
	tween = create_tween()
	tween.tween_property(fade_rect, "color:a", 0.0, 0.5)
	await tween.finished
	
	loading_active = false
	loading_text.visible = false
	animated_sprite2d.visible = false

func animate_loading_text():
	var dots = 0
	
	while loading_active:
		dots = (dots + 1) % 4
		
		var text = "Carregando"
		for i in dots:
			text += "."
		
		loading_text.text = text
		
		await get_tree().create_timer(0.4).timeout
		
func change_scene_with_loading(path: String):
	await fade_out()
	
	get_tree().change_scene_to_file(path)
	
	await get_tree().create_timer(3.0).timeout
	
	await fade_in()
