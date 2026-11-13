extends CanvasLayer

signal dialog_finished

enum Side { LEFT, RIGHT }

@export var bg_color: Color = Color(0, 0, 0, 0.6)
@export var border_color: Color = Color(0, 0, 0, 0.6)
@export var text_color: Color = Color(1, 1, 1, 1)
@export var name_color: Color = Color(1, 0.8, 0.2)

@export var side: Side
@export var animation: String

# Velocidade da digitação
@export var text_speed: float = 0.03

# Quantos caracteres precisam aparecer antes de tocar o som
@export var sound_every_characters: int = 3

# Variação do pitch dos sons
@export var pitch_min: float = 0.92
@export var pitch_max: float = 1.08


@onready var name_label = %NameLabel
@onready var text_label = %RichTextLabel
@onready var portrait = %AnimatedSprite2D
@onready var ponto = %AnimatedSprite2D2
@onready var panel = %Panel

@onready var player = get_tree().get_first_node_in_group("player")

# Áudios dos personagens
@onready var player_voice = $PlayerVoice
@onready var eduardo_voice = $EduardoVoice
@onready var mamae_voice = $MamaeVoice
@onready var vini_voice = $ViniVoice
@onready var nik_voice = $NikVoice
@onready var joao_voice = $JoaoVoice


var panel_style: StyleBoxFlat

var dialog = []
var index = 0

var is_active = false
var input_locked = false

# Controle da velocidade do texto
var text_timer: float = 0.0

# Controle de quantos caracteres apareceram
var sound_counter: int = 0


func _ready():

	hide()

	# Fundo do panel
	panel_style = StyleBoxFlat.new()
	panel_style.bg_color = bg_color

	panel_style.border_width_bottom = 2
	panel_style.border_width_left = 2
	panel_style.border_width_right = 2
	panel_style.border_width_top = 2

	panel_style.border_color = border_color

	panel.add_theme_stylebox_override("panel", panel_style)

	# Cor do texto
	text_label.add_theme_color_override(
		"default_color",
		text_color
	)

	# Cor do nome
	name_label.add_theme_color_override(
		"font_color",
		name_color
	)


func start_dialog(dialog_data):

	dialog = dialog_data
	index = 0
	is_active = true

	if player:
		player.can_move = false

	show()

	show_line()


func set_portrait_side(side: Side):

	if side == Side.LEFT:

		portrait.flip_h = false
		portrait.position.x = 32.0
		ponto.position.x = 265.0

	else:

		portrait.flip_h = true
		portrait.position.x = 256.0
		ponto.position.x = 15


func show_line():

	if index >= dialog.size():

		end_dialog()
		return

	var line = dialog[index]

	# Nome
	name_label.text = line["name"]

	# Texto
	text_label.text = line["text"]

	# Começa o texto novamente
	text_label.visible_characters = 0

	# Reseta o timer
	text_timer = 0.0

	# Reseta contador do som
	sound_counter = 0

	# Animação do personagem
	portrait.play(
		line.get("animation", animation)
	)

	# Lado do personagem
	var line_side = line.get(
		"side",
		Side.RIGHT
	)

	set_portrait_side(line_side)

	# Cor do nome
	name_label.modulate = line.get(
		"name_color",
		name_color
	)

	# Cor da borda
	panel_style.border_color = line.get(
		"border_color",
		border_color
	)


func _process(delta):

	if not is_active:
		return

	# Ainda está escrevendo?
	if text_label.visible_characters < text_label.get_total_character_count():

		text_timer -= delta

		if text_timer <= 0.0:

			text_timer = text_speed

			# Mostra próximo caractere
			text_label.visible_characters += 1

			# Pega posição do caractere
			var character_index = text_label.visible_characters - 1

			var current_text = text_label.text

			if character_index >= 0 and character_index < current_text.length():

				var character = current_text[character_index]

				# Ignora espaços e pontuação
				if character != " " and not ". ,!?;:".contains(character):

					sound_counter += 1

					# Toca som depois de alguns caracteres
					if sound_counter >= sound_every_characters:

						sound_counter = 0

						tocar_som_personagem()


func tocar_som_personagem():

	var voice: AudioStreamPlayer = null

	match name_label.text.to_lower():

		"kath":
			voice = player_voice

		"eddw":
			voice = eduardo_voice

		"mamae", "mamãe":
			voice = mamae_voice

		"joao":
			voice = joao_voice

		"vini":
			voice = vini_voice

		"nik":
			voice = nik_voice

		_:
			return

	if voice == null:
		return

	# Pequena variação para não ficar repetitivo
	voice.pitch_scale = randf_range(
		pitch_min,
		pitch_max
	)

	voice.play()


func _input(event):

	if not is_active:
		return

	if event.is_action_pressed("interact"):

		next_line()

		get_viewport().set_input_as_handled()


func next_line():

	if not is_active:
		return

	# Se ainda está escrevendo → completa o texto
	if text_label.visible_characters < text_label.get_total_character_count():

		text_label.visible_characters = text_label.get_total_character_count()

		# Para o som imediatamente
		parar_sons()

	else:

		index += 1

		show_line()


func parar_sons():

	player_voice.stop()
	eduardo_voice.stop()
	mamae_voice.stop()
	vini_voice.stop()
	nik_voice.stop()
	joao_voice.stop()


func end_dialog():

	parar_sons()

	hide()

	is_active = false
	input_locked = true

	await get_tree().create_timer(0.2).timeout

	input_locked = false

	if player:
		player.can_move = true

	dialog_finished.emit()
