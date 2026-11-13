extends Node
class_name DecorationController

var notas_sprites = []

var notas_ativas = []

var posicoes_originais = {}

var main

func initialize(main_node):

	main = main_node

	notas_sprites = [
		main.get_node("CanvasLayer/Game/notas/Notas"),
		main.get_node("CanvasLayer/Game/notas/Notas1"),
		main.get_node("CanvasLayer/Game/notas/Notas2"),
		main.get_node("CanvasLayer/Game/notas/Notas3"),
		main.get_node("CanvasLayer/Game/notas/Notas4")
	]

	posicoes_originais.clear()

	for nota in notas_sprites:

		posicoes_originais[nota] = nota.position

		nota.visible = false
		nota.modulate.a = 1.0

func _process(delta):

	if !main.game.esta_jogando():
		return

	for nota in notas_ativas.duplicate():

		nota.position.y -= 100 * delta

		nota.modulate.a -= delta * 2

		if nota.modulate.a <= 0:

			resetar_nota(nota)
			
func criar_nota():

	if notas_sprites.is_empty():
		return

	var nota = notas_sprites[randi() % notas_sprites.size()]

	if nota in notas_ativas:
		return

	nota.position = posicoes_originais[nota]
	nota.frame = randi() % 3
	nota.visible = true
	nota.modulate.a = 1.0

	notas_ativas.append(nota)
	
func resetar_nota(nota):

	if nota == null:
		return

	nota.visible = false

	nota.modulate.a = 1.0

	nota.position = posicoes_originais[nota]

	if nota in notas_ativas:
		notas_ativas.erase(nota)

func limpar():

	for nota in notas_ativas.duplicate():

		resetar_nota(nota)

	notas_ativas.clear()

func resetar():

	limpar()
	
func _on_spawn_note(lane):

	criar_nota()
