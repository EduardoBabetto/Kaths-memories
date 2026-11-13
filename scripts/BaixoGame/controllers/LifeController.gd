extends Node
class_name LifeController

signal life_changed(vida_hits)
signal game_over

var vida_maxima := 6

var vida_hits := vida_maxima

var main

func initialize(main_node):

	main = main_node

func resetar():

	vida_hits = vida_maxima

	emit_signal("life_changed", vida_hits)
	
	
func perder_vida():

	if vida_hits <= 0:
		return

	vida_hits -= 1

	emit_signal("life_changed", vida_hits)

	if vida_hits <= 0:

		vida_hits = 0

		emit_signal("game_over")
	
func ganhar_vida():

	vida_hits += 1

	if vida_hits > vida_maxima:
		vida_hits = vida_maxima

	emit_signal("life_changed", vida_hits)

func get_vida():
	return vida_hits

func esta_vivo():

	return vida_hits > 0

func on_note_passed(tecla):

	perder_vida()
		
func curar_total():

	vida_hits = vida_maxima

	emit_signal("life_changed", vida_hits)
	
func esta_morto():

	return vida_hits == 0
	
func get_lifes_lost():
	return vida_maxima - vida_hits
