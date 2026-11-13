extends CanvasLayer

# Menu de pausa universal. Recomendado configurar como Autoload
# (Project Settings > Autoload) para funcionar em qualquer fase sem
# precisar duplicar a cena — assim ele fica sempre disponível na raiz
# da árvore, independente de qual fase está carregada.

@export var cena_menu_principal: String = "res://scenes/rooms/title_screen.tscn"

@onready var panel: Panel = $Panel
@onready var color_rect = $ColorRect
@onready var painel_controles = $Controles/CanvasLayer
@onready var botao_play: Button = $Panel/VBoxContainer/Play
@onready var botao_controles: Button = $Panel/VBoxContainer/Controles
@onready var botao_quit: Button = $Panel/VBoxContainer/Quit

var can_press = false

func _ready():
	
	var cena_atual = get_tree().current_scene.name

	if cena_atual == "TitleScreen" or cena_atual == "dormindo" :
		process_mode = Node.PROCESS_MODE_DISABLED
	else:
		process_mode = Node.PROCESS_MODE_ALWAYS
		
	visible = false
	
	painel_controles.visible = false

	botao_play.pressed.connect(retomar)
	botao_controles.pressed.connect(abrir_controles)
	botao_quit.pressed.connect(sair_para_menu)
	
	get_tree().node_added.connect(_ao_mudar_de_cena)

func _ao_mudar_de_cena(node: Node) -> void:
	# Aguarda um frame para garantir que a Godot definiu o current_scene corretamente
	await get_tree().process_frame
	
	# Verifica se o nó adicionado é de fato a cena principal atual
	if node == get_tree().current_scene:
		var cena_atual = node.name
		
		# Aplica a sua lógica de desativar/ativar o processo
		if cena_atual == "TitleScreen" or cena_atual == "Dormindo":
			process_mode = Node.PROCESS_MODE_DISABLED
			print("Cena global DESATIVADA em: ", cena_atual)
		else:
			process_mode = Node.PROCESS_MODE_ALWAYS
			print("Cena global ATIVADA em: ", cena_atual)

func _unhandled_input(event):

	# Requer uma action "pause" configurada em Project Settings >
	# Input Map (normalmente mapeada pra tecla Esc).
	
	if event.is_action_pressed("pause"):

		if visible:
			retomar()
		else:
			abrir_pausa()

		get_viewport().set_input_as_handled()

func _input(event):
	if can_press and event.is_pressed():
		painel_controles.hide()
		panel.visible = true
		color_rect.visible = true
		
func abrir_pausa():
	visible = true
	panel.visible = true
	painel_controles.hide()
	get_tree().paused = true


func retomar():
	visible = false
	get_tree().paused = false


func abrir_controles():
	color_rect.visible = false
	panel.visible = false
	painel_controles.show()
	fechar_controles()

func fechar_controles():
	await get_tree().create_timer(1.0).timeout
	can_press = true


func sair_para_menu():
	visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file(cena_menu_principal)\
