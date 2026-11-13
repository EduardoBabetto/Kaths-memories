extends Node
class_name ScoreController

signal score_changed(score, multiplicador)

var ui: UIController

var score := 0

var combo := 0

var multiplicador := 1

var score_multiplier := 1.0

var penalidade_erro := 300

var combo_maximo := 0

var perfect := 0
var good := 0
var late := 0
var miss := 0

var notas_acertadas := 0
var notas_totais := 0

var main

func initialize(main_node):

	main = main_node
	ui = main.ui

func get_score():

	return score

func get_combo():

	return combo

func get_multiplier():

	return multiplicador
	
func resetar():

	score = 0
	combo = 0
	multiplicador = 1

	combo_maximo = 0

	perfect = 0
	good = 0
	late = 0
	miss = 0

	notas_acertadas = 0

	notas_totais = 0

	if main.beatmap.beatmap_data.has("notes"):
		notas_totais = main.beatmap.beatmap_data["notes"].size()

	emit_signal("score_changed", score, multiplicador)

func registrar_erro():
	combo = 0
	multiplicador = 1

	emit_signal("score_changed", score, multiplicador)

func registrar_acerto(rating):

	var pontos := 0

	match rating:

		"perfect":
			pontos = 50
			perfect += 1

		"good":
			pontos = 35
			good += 1

		"late":
			pontos = 20
			late += 1

	notas_acertadas += 1

	combo += 1

	if combo > combo_maximo:
		combo_maximo = combo

	multiplicador = min(4, 1 + int(combo / 10))

	score += pontos * multiplicador * score_multiplier

	emit_signal("score_changed", score, multiplicador)

func on_note_hit(rating, lane):
	registrar_acerto(rating)

func on_note_passed(tecla):

	miss += 1

	combo = 0
	multiplicador = 1

	score -= penalidade_erro

	if score < 0:
		score = 0

	emit_signal("score_changed", score, multiplicador)
	
func on_wrong_input(tecla):
	
	miss+= 1
	combo = 0
	multiplicador = 1

	emit_signal("score_changed", score, multiplicador)
	

func get_accuracy():

	if notas_totais == 0:
		return 0.0

	var pontos := 0.0

	pontos += perfect * 1.0
	pontos += good * 0.7
	pontos += late * 0.4

	return (pontos / notas_totais) * 100.0
	
	
func get_rank():

	var acc = get_accuracy()

	if acc >= 99:
		return "SS"

	elif acc >= 95:
		return "S"

	elif acc >= 90:
		return "A"

	elif acc >= 80:
		return "B"

	elif acc >= 70:
		return "C"

	elif acc >= 60:
		return "D"

	return "F"
	

func get_rank_comment():

	match get_rank():

		"SS":
			return "GODDAMMM!A mais mais ai"

		"S":
			return "YESSSSSSSS!!!"

		"A":
			return "Ta chegando em algum lugar em!"

		"B":
			return "Da pro gasto"

		"C":
			return "Larga o zap, foca ai"

		"D":
			return "Você não era a mais mais?"

		_:
			return "Nem tentou, namoral"
			
func get_result_data():

	var musica = main.beatmap.get_musica_selecionada()

	return {

		#========================
		# Música
		#========================

		"title": musica.get("title",""),

		"artist": musica.get("artist",""),

		"difficulty": musica.get("difficulty",""),

		"cover": musica.get("cover",""),

		"bpm": musica.get("bpm",0),

		"creator": musica.get("creator",""),

		"album": musica.get("album",""),

		#========================
		# Score
		#========================

		"score": score,

		"combo_maximo": combo_maximo,

		"perfect": perfect,

		"good": good,

		"late": late,

		"miss": miss,

		"accuracy": get_accuracy(),

		"hit_rate": get_hit_rate(),

		"notes_string": get_notes_string(),

		"rank": get_rank(),

		"comment": get_rank_comment(),

		"notas_acertadas": notas_acertadas,

		"notas_totais": notas_totais,

		"vidas_perdidas": main.vidas.get_lifes_lost()

	}
func get_hit_rate():

	if notas_totais == 0:
		return 0.0

	return (float(notas_acertadas) / notas_totais) * 100.0

func get_notes_string():

	return "%d / %d" % [
		notas_acertadas,
		notas_totais
	]
