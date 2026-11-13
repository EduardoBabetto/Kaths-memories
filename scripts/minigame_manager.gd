extends Node
signal _enter_minigame
signal _out_minigame
var current_minigame: Node = null
var camera_anterior: Camera2D = null

func _ready():
	add_to_group("minigame_manager")

func open(scene: PackedScene):
	if current_minigame != null:
		return
	print("ABRINDO MINIGAME")
	camera_anterior = get_viewport().get_camera_2d()

	# Instancia PRIMEIRO
	current_minigame = scene.instantiate()
	get_tree().root.add_child(current_minigame)

	# Faz o minigame funcionar normalmente, sem depender de pause
	current_minigame.process_mode = Node.PROCESS_MODE_ALWAYS

	# Conecta fechamento
	if current_minigame.has_signal("closed"):
		current_minigame.closed.connect(_on_minigame_closed)
	else:
		print("ERRO: Minigame não possui sinal closed")

	# Suspende a cena Memories (ela já desliga física e processamento
	# própria via process_mode = DISABLED). NÃO usamos
	# get_tree().paused aqui — isso quebra a detecção de Area2D
	# (get_overlapping_bodies) mesmo com PROCESS_MODE_ALWAYS forçado
	# em tudo. A suspensão da Memories já é suficiente para isolar
	# o overworld enquanto o minigame roda.
	emit_signal("_enter_minigame")

	current_minigame.abrir()

func _on_minigame_closed():
	print("FECHANDO MINIGAME")

	if is_instance_valid(current_minigame):
		current_minigame.queue_free()
	current_minigame = null

	if is_instance_valid(camera_anterior):
		camera_anterior.make_current()
	camera_anterior = null

	emit_signal("_out_minigame")
