extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ziggs_audio: AudioStreamPlayer = $Ziggs

@onready var dialog_box = get_tree().get_first_node_in_group("Labuziggs_interativo")

var ativado := false


func _ready() -> void:

	# Começa na animação normal
	sprite.play("default")

	# Conecta ao sinal do DialogBox
	if dialog_box:

		if not dialog_box.dialog_finished.is_connected(_on_dialog_finished):
			dialog_box.dialog_finished.connect(_on_dialog_finished)

	else:

		print("ERRO: DialogBox não encontrado!")


func _on_dialog_finished() -> void:

	# Evita executar mais de uma vez
	if ativado:
		return

	ativado = true

	print("Diálogo do Labuziggs terminou!")

	# Muda a animação
	sprite.play("isqueiro")

	# Toca o áudio
	if ziggs_audio:
		ziggs_audio.play()
	else:
		print("ERRO: AudioStreamPlayer Ziggs não encontrado!")
