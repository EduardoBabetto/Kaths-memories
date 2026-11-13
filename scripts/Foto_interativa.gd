extends Node2D

@export var dialog_data = [
	{
	"name": "Kath",
		"text": "Eu lembro dessa foto!",
		"text_color": Color(1, 0, 0),
		"bg_color": Color(0, 0, 0, 0.8),
		"border_color": Color(0.0, 1.643, 0.339, 1.0),
		"animation": "Kath",
		"side": Side.SIDE_LEFT
	},
	{
		"name": "Kath",
		"text": "A Eve ta tão fofinha nela...",
		"text_color": Color(1, 0, 0),
		"bg_color": Color(0, 0, 0, 0.8),
		"border_color": Color(0.0, 1.643, 0.339, 1.0),
		"animation": "Kath",
		"side": Side.SIDE_LEFT
	},
	{
		"name": "Kath",
		"text": "Vai virar capa da minha playlist!",
		"text_color": Color(1, 0, 0),
		"bg_color": Color(0, 0, 0, 0.8),
		"border_color": Color(0.0, 1.643, 0.339, 1.0),
		"animation": "Kath",
		"side": Side.SIDE_LEFT
	},
]

var player_inside = false
var activated = false
@onready var interact_icon = %AnimatedSprite2D
@onready var photo_screen = $"/root/Memories/72h/PhotoScreen"
@onready var animation_player = $"/root/Memories/72h/PhotoScreen/AnimationPlayer"
var time := 0.0
@onready var dialog_box = get_tree().get_first_node_in_group("dialog")


func _ready():
	interact_icon.hide()
	photo_screen.hide()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player_inside = true
		interact_icon.show()
		
func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		player_inside = false
		interact_icon.hide()
		
func abrir_interacao():
	interact_icon.hide()

	# mostra tela
	photo_screen.show()

	# toca fade in
	animation_player.play("Fade_in")
	await animation_player.animation_finished

	# começa diálogo
	dialog_box.start_dialog(dialog_data)

	# espera diálogo acabar
	while dialog_box.is_active:
		await get_tree().process_frame

	# toca fade out
	animation_player.play("Fade_out")
	await animation_player.animation_finished

	# esconde tela
	photo_screen.hide()

	# mostra ícone de novo
	if player_inside:
		interact_icon.show()
		
func _process(delta):
	time += delta
	interact_icon.position.y = -40 + sin(time * 3) * 5

	if player_inside and Input.is_action_just_pressed("interact"):
		if not dialog_box.is_active and not dialog_box.input_locked:
			abrir_interacao()
			
			
