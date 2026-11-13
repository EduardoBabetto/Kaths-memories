extends Node2D

signal dialogo_finished


# ==================================================
# PRIMEIRO DIÁLOGO
# ==================================================

@export var dialog_data = [
	{
		"name": "Kath",
		"text": "Ai meu Deus",
		"text_color": Color(1, 0, 0),
		"bg_color": Color(0, 0, 0, 0.8),
		"border_color": Color(0.0, 1.643, 0.339, 1.0),
		"animation": "Kath",
		"side": Side.SIDE_RIGHT
	},
	{
		"name": "Kath",
		"text": "Que vontade de jogar Bloons!!!",
		"text_color": Color(1, 0, 0),
		"bg_color": Color(0, 0, 0, 0.8),
		"border_color": Color(0.0, 1.643, 0.339, 1.0),
		"animation": "Kath",
		"side": Side.SIDE_RIGHT
	}
]


# ==================================================
# SEGUNDO DIÁLOGO
# ==================================================

@export var dialog_data_queimado = [
	{
		"name": "Kath",
		"text": "MAS NEM LIGOU DIREITO E ELE EXPLODIU?!",
		"text_color": Color(1, 0, 0),
		"bg_color": Color(0, 0, 0, 0.8),
		"border_color": Color(1, 0, 0, 1),
		"animation": "Kath",
		"side": Side.SIDE_RIGHT
	},
	{
		"name": "Kath",
		"text": "Fez até barulho de microondas slk...",
		"text_color": Color(1, 0, 0),
		"bg_color": Color(0, 0, 0, 0.8),
		"border_color": Color(1, 0, 0, 1),
		"animation": "Kath",
		"side": Side.SIDE_RIGHT
	}
]


var player_inside := false
var computador_queimado := false

# Diz se estamos esperando o primeiro diálogo terminar
var esperando_primeiro_dialogo := false

var time := 0.0


@onready var interact_icon = %AnimatedSprite2D
@onready var dialog_box = get_tree().get_first_node_in_group("dialog")


func _ready():

	interact_icon.hide()

	print("=== COMPUTADOR DIALOGO INICIADO ===")

	if dialog_box:

		print("DialogBox encontrado!")

		if not dialog_box.dialog_finished.is_connected(_on_dialog_box_finished):
			dialog_box.dialog_finished.connect(_on_dialog_box_finished)

	else:

		print("ERRO: DialogBox NÃO encontrado!")


func _on_area_2d_body_entered(body):

	if not body.is_in_group("player"):
		return

	if computador_queimado:
		return

	player_inside = true

	interact_icon.show()

	print("Player entrou no computador")


func _on_area_2d_body_exited(body):

	if not body.is_in_group("player"):
		return

	player_inside = false

	interact_icon.hide()


func _process(delta):

	time += delta

	interact_icon.position.y = -40 + sin(time * 3) * 5

	if computador_queimado:
		return

	if player_inside and Input.is_action_just_pressed("interact"):

		if not dialog_box.is_active and not dialog_box.input_locked:

			print("Iniciando primeiro diálogo")

			# Agora estamos esperando o DialogBox terminar
			esperando_primeiro_dialogo = true

			dialog_box.start_dialog(dialog_data)

			interact_icon.hide()


func _on_dialog_box_finished():

	print("=== DIALOG BOX TERMINOU ===")

	# Se não estamos esperando o primeiro diálogo,
	# não faz nada
	if not esperando_primeiro_dialogo:
		print("Não estava esperando o primeiro diálogo")
		return

	# Impede que aconteça novamente
	esperando_primeiro_dialogo = false

	# Se já queimou, não faz nada
	if computador_queimado:
		return

	print("Primeiro diálogo realmente terminou!")

	# Avisa o PC
	dialogo_finished.emit()

	print("Sinal dialogo_finished enviado para o PC")


func mostrar_dialogo_queimado():

	print("=== MOSTRANDO DIÁLOGO DO PC QUEIMADO ===")

	computador_queimado = true

	player_inside = false

	interact_icon.hide()

	if dialog_box:

		if not dialog_box.is_active and not dialog_box.input_locked:

			dialog_box.start_dialog(dialog_data_queimado)

		else:

			print("ERRO: DialogBox ainda está ocupado!")

	else:

		print("ERRO: DialogBox não encontrado!")
