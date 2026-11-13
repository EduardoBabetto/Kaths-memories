extends Node2D

# Anexe este script ao nó "Limites". Ele configura automaticamente
# a layer/mask de todos os StaticBody2D filhos (Cima, Baixo, Esquerda,
# Direita), então você não precisa mexer em cada um manualmente.
#
# Layer 3 (bit 1<<2) = mundo/limites. Paredes não precisam detectar
# nada (mask = 0), só bloquear quem colide com essa layer.

func _ready():

	for filho in get_children():

		if filho is StaticBody2D:

			filho.collision_layer = 1 << 2
			filho.collision_mask = 0

			var shape = filho.get_node_or_null("CollisionShape2D")

			if shape == null:
				print("AVISO (Limites): ", filho.name, " não possui CollisionShape2D!")
			elif shape.shape == null:
				print("AVISO (Limites): ", filho.name, " está sem Shape atribuído no Inspector!")
			else:
				shape.disabled = false
