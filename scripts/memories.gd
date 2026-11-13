extends Node2D

@onready var dialog_box = $dialog_box
@onready var sd = $SoundTrack
@onready var minigame_manager = $MinigameManager


func _ready() -> void:

	minigame_manager._enter_minigame.connect(_enter_minigame)
	minigame_manager._out_minigame.connect(_out_minigame)

	sd.play()


func _input(event):

	if event.is_action_pressed("ui_accept"):

		if dialog_box.is_active:
			dialog_box.next_line()


func _enter_minigame():

	print("MEMORIES: suspendendo completamente")

	sd.stop()

	# Desliga TODA a física da cena Memories
	desativar_fisica(self)

	desativar_cameras(self)

	visible = false

	process_mode = Node.PROCESS_MODE_DISABLED


# ==========================================================
# SAIR DO MINIGAME
# ==========================================================

func _out_minigame():

	print("MEMORIES: restaurando")

	# Primeiro restaura física
	ativar_fisica(self)

	# Restaura câmeras
	ativar_cameras(self)

	# Mostra novamente
	visible = true

	# Volta processamento
	process_mode = Node.PROCESS_MODE_INHERIT

	sd.play()


# ==========================================================
# DESATIVAR FÍSICA
# ==========================================================

# ==========================================================
# MEMORIES
# SUBSTITUA desativar_fisica() POR ESTE
# ==========================================================

func desativar_fisica(node: Node):

	# Nunca entra no minigame.
	if node.is_in_group("minigame_runtime"):
		return


	for filho in node.get_children():

		# Nunca mexe no minigame.
		if filho.is_in_group("minigame_runtime"):
			continue


		if filho is CollisionShape2D:

			if not filho.has_meta(
				"memories_original_disabled"
			):

				filho.set_meta(
					"memories_original_disabled",
					filho.disabled
				)

			filho.disabled = true


		if filho is CollisionPolygon2D:

			if not filho.has_meta(
				"memories_original_disabled"
			):

				filho.set_meta(
					"memories_original_disabled",
					filho.disabled
				)

			filho.disabled = true


		if filho is CollisionObject2D:

			if not filho.has_meta(
				"memories_original_layer"
			):

				filho.set_meta(
					"memories_original_layer",
					filho.collision_layer
				)

			if not filho.has_meta(
				"memories_original_mask"
			):

				filho.set_meta(
					"memories_original_mask",
					filho.collision_mask
				)

			filho.collision_layer = 0
			filho.collision_mask = 0


		if filho is Area2D:

			if not filho.has_meta(
				"memories_original_monitoring"
			):

				filho.set_meta(
					"memories_original_monitoring",
					filho.monitoring
				)

			if not filho.has_meta(
				"memories_original_monitorable"
			):

				filho.set_meta(
					"memories_original_monitorable",
					filho.monitorable
				)

			filho.monitoring = false
			filho.monitorable = false


		if filho is TileMapLayer:

			if not filho.has_meta(
				"memories_original_enabled"
			):

				filho.set_meta(
					"memories_original_enabled",
					filho.enabled
				)

			if not filho.has_meta(
				"memories_original_collision"
			):

				filho.set_meta(
					"memories_original_collision",
					filho.collision_enabled
				)

			filho.enabled = false
			filho.collision_enabled = false


		desativar_fisica(filho)

func ativar_fisica(node: Node):

	if node.is_in_group("minigame_runtime"):
		return


	for filho in node.get_children():

		if filho.is_in_group("minigame_runtime"):
			continue


		if filho is CollisionShape2D:

			if filho.has_meta(
				"memories_original_disabled"
			):

				filho.disabled = filho.get_meta(
					"memories_original_disabled"
				)


		if filho is CollisionPolygon2D:

			if filho.has_meta(
				"memories_original_disabled"
			):

				filho.disabled = filho.get_meta(
					"memories_original_disabled"
				)


		if filho is CollisionObject2D:

			if filho.has_meta(
				"memories_original_layer"
			):

				filho.collision_layer = filho.get_meta(
					"memories_original_layer"
				)

			if filho.has_meta(
				"memories_original_mask"
			):

				filho.collision_mask = filho.get_meta(
					"memories_original_mask"
				)


		if filho is Area2D:

			if filho.has_meta(
				"memories_original_monitoring"
			):

				filho.monitoring = filho.get_meta(
					"memories_original_monitoring"
				)

			if filho.has_meta(
				"memories_original_monitorable"
			):

				filho.monitorable = filho.get_meta(
					"memories_original_monitorable"
				)


		if filho is TileMapLayer:

			if filho.has_meta(
				"memories_original_enabled"
			):

				filho.enabled = filho.get_meta(
					"memories_original_enabled"
				)

			if filho.has_meta(
				"memories_original_collision"
			):

				filho.collision_enabled = filho.get_meta(
					"memories_original_collision"
				)


		ativar_fisica(filho)

func desativar_cameras(node: Node):

	for filho in node.get_children():

		if filho is Camera2D:

			filho.set_meta(
				"camera_enabled_original",
				filho.enabled
			)

			filho.enabled = false

		desativar_cameras(filho)


func ativar_cameras(node: Node):

	for filho in node.get_children():

		if filho is Camera2D:
			if filho.has_meta("camera_enabled_original"):

				filho.enabled = filho.get_meta(
					"camera_enabled_original"
				)

		ativar_cameras(filho)
