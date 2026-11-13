extends Node2D


@onready var computador_dialogo = get_tree().get_first_node_in_group("ComputadorDialogo")

@onready var pc_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var microondas: AudioStreamPlayer = $Microondas
@onready var estouro: AudioStreamPlayer = $Estouro


var processo_ativo := false
var pc_queimado := false


func _ready() -> void:

	print("=== PC INICIADO ===")

	# ==================================================
	# PC COMEÇA DESLIGADO
	# ==================================================

	pc_sprite.play("Desligado")

	print("Animação inicial: ", pc_sprite.animation)


	# ==================================================
	# PROCURA O COMPUTADOR DIALOGO
	# ==================================================

	if computador_dialogo:

		print("ComputadorDialogo encontrado!")

		if not computador_dialogo.dialogo_finished.is_connected(_on_dialog_finished):

			computador_dialogo.dialogo_finished.connect(_on_dialog_finished)

			print("Sinal conectado com sucesso!")

	else:

		print("ERRO GRAVE: ComputadorDialogo NÃO encontrado!")


	# ==================================================
	# VERIFICA OS ÁUDIOS
	# ==================================================

	if microondas:

		print("Microondas encontrado!")

	else:

		print("ERRO: Microondas não encontrado!")


	if estouro:

		print("Estouro encontrado!")

	else:

		print("ERRO: Estouro não encontrado!")


func _on_dialog_finished() -> void:

	print("================================")
	print("PC RECEBEU O SINAL!")
	print("================================")


	# ==================================================
	# EVITA EXECUTAR NOVAMENTE
	# ==================================================

	if processo_ativo:

		print("Processo já estava ativo.")

		return


	if pc_queimado:

		print("PC já está queimado.")

		return


	processo_ativo = true


	# ==================================================
	# 1. LIGA O PC
	# ==================================================

	print("LIGANDO PC...")

	pc_sprite.play("Ligado")

	print("Animação atual: ", pc_sprite.animation)


	# ==================================================
	# 2. TOCA MICROONDAS
	# ==================================================

	print("Tocando Microondas...")

	if microondas:

		microondas.play()

	else:

		print("ERRO: Microondas é NULL!")


	# ==================================================
	# 3. ESPERA 3 SEGUNDOS
	# ==================================================

	print("Esperando 3 segundos...")

	await get_tree().create_timer(3.0).timeout


	print("3 segundos terminaram!")


	# ==================================================
	# 4. PARA MICROONDAS
	# ==================================================

	if microondas:

		print("Parando Microondas...")

		microondas.stop()


	# ==================================================
	# 5. TOCA ESTOURO
	# ==================================================

	print("TOCANDO ESTOURO!")

	if estouro:

		estouro.play()

	else:

		print("ERRO: Estouro é NULL!")


	# ==================================================
	# 6. MUDA PARA QUEIMADO
	# ==================================================

	print("Mudando PC para QUEIMADO!")

	pc_sprite.play("Queimado")

	print("Animação atual: ", pc_sprite.animation)


	# ==================================================
	# 7. MARCA COMO QUEIMADO
	# ==================================================

	pc_queimado = true


	# ==================================================
	# 8. DESATIVA A INTERAÇÃO
	# ==================================================

	var area = $AnimatedSprite2D/Area2D

	if area:

		area.set_deferred("monitoring", false)
		area.set_deferred("monitorable", false)

		print("Área de interação desativada!")


	# ==================================================
	# 9. ESPERA UM POUCO
	# ==================================================

	await get_tree().create_timer(0.5).timeout


	# ==================================================
	# 10. MOSTRA SEGUNDO DIÁLOGO
	# ==================================================

	print("Chamando segundo diálogo!")

	if computador_dialogo:

		computador_dialogo.mostrar_dialogo_queimado()

	else:

		print("ERRO: ComputadorDialogo desapareceu!")
