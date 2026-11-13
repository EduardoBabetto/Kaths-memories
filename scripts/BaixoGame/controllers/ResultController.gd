extends Node
class_name ResultController

signal retry_pressed
signal song_select_pressed
signal menu_pressed
signal enter_result

var main

var tela

var cover

var titulo

var artista

var dificuldade

var score

var accuracy

var combo

var perfect

var good

var late

var miss

var notes

var vidas

var rank

var comentario

var retry

var song_select

var menu

var animation

var resultado

func initialize(main_node):
	

	main = main_node

	tela = main.get_node("CanvasLayer/Resultado")
	tela.hide()

	cover = main.get_node("CanvasLayer/Resultado/MarginContainer/VBoxContainer/Header/Panel/HBoxContainer/Cover")

	titulo = main.get_node("CanvasLayer/Resultado/MarginContainer/VBoxContainer/Header/Panel/HBoxContainer/VBoxContainer/SongTitle")
	
	artista = main.get_node("CanvasLayer/Resultado/MarginContainer/VBoxContainer/Header/Panel/HBoxContainer/VBoxContainer/Artist")
	
	dificuldade = main.get_node("CanvasLayer/Resultado/MarginContainer/VBoxContainer/Header/Panel/HBoxContainer/VBoxContainer/Difficulty")
	
	score = main.get_node("CanvasLayer/Resultado/MarginContainer/VBoxContainer/StatsPanel/HBoxContainer/GridContainer/ScoreValue")
	
	accuracy = main.get_node("CanvasLayer/Resultado/MarginContainer/VBoxContainer/StatsPanel/HBoxContainer/GridContainer/AccuracyValue")
	
	combo = main.get_node("CanvasLayer/Resultado/MarginContainer/VBoxContainer/StatsPanel/HBoxContainer/GridContainer/ComboValue")
	
	perfect = main.get_node("CanvasLayer/Resultado/MarginContainer/VBoxContainer/StatsPanel/HBoxContainer/GridContainer2/PerfectValue")
	
	good = main.get_node("CanvasLayer/Resultado/MarginContainer/VBoxContainer/StatsPanel/HBoxContainer/GridContainer2/GoodValue")
	
	late = main.get_node(
	"CanvasLayer/Resultado/MarginContainer/VBoxContainer/StatsPanel/HBoxContainer/GridContainer2/LateValue"
	)
	
	miss = main.get_node("CanvasLayer/Resultado/MarginContainer/VBoxContainer/StatsPanel/HBoxContainer/GridContainer2/MissValue")
	
	notes = main.get_node("CanvasLayer/Resultado/MarginContainer/VBoxContainer/StatsPanel/HBoxContainer/GridContainer/NotesValue")
	
	vidas = main.get_node("CanvasLayer/Resultado/MarginContainer/VBoxContainer/StatsPanel/HBoxContainer/GridContainer2/LifeLostValue")
	
	rank = main.get_node("CanvasLayer/Resultado/MarginContainer/VBoxContainer/RankPanel/VBoxContainer/RankImage")
	
	comentario = main.get_node("CanvasLayer/Resultado/MarginContainer/VBoxContainer/RankPanel/VBoxContainer/AccuracyComment")
	
	retry = main.get_node("CanvasLayer/Resultado/MarginContainer/VBoxContainer/Buttons/HboxContainer/ReplayButton")
	
	song_select = main.get_node("CanvasLayer/Resultado/MarginContainer/VBoxContainer/Buttons/HboxContainer/SongSelectButton")
	
	menu = main.get_node("CanvasLayer/Resultado/MarginContainer/VBoxContainer/Buttons/HboxContainer/MenuButton")
	
	animation = main.get_node("CanvasLayer/Resultado/AnimationPlayer")


	setup()
	

func setup():
	retry.pressed.connect(_on_retry)
	song_select.pressed.connect(_on_song_select)
	menu.pressed.connect(_on_menu)
	

func abrir():
	resultado = main.score.get_result_data()

	tela.show()

	if animation.has_animation("fade_in"):
		animation.play("fade_in")
		
	await preencher()
	emit_signal("enter_result")
		
func fechar():

	if animation.has_animation("close"):

		animation.play("close")

		await animation.animation_finished

	tela.hide()
	
func preencher():

	titulo.text = resultado["title"]

	artista.text = resultado["artist"]

	dificuldade.text = resultado["difficulty"]

	if resultado["cover"] != "":
		cover.texture = load(resultado["cover"])
	else:
		cover.texture = null

	animar_numero(score, resultado["score"])

	animar_numero(combo, resultado["combo_maximo"])

	animar_numero(perfect, resultado["perfect"])

	animar_numero(good, resultado["good"])

	animar_numero(late, resultado["late"])

	animar_numero(miss, resultado["miss"])

	animar_porcentagem(
	accuracy,
	resultado["accuracy"]
	)
	
	atualizar_rank()

	comentario.text = resultado["comment"]
	
	animar_notes(resultado["notas_acertadas"],resultado["notas_totais"])
	animar_hit_rate(resultado["hit_rate"])
	
	animar_numero(vidas, resultado["vidas_perdidas"])
	
func _on_retry():

	emit_signal("retry_pressed")

func _on_song_select():

	emit_signal("song_select_pressed")

func _on_menu():
	emit_signal("menu_pressed")
	
func atualizar_rank():

	match resultado["rank"]:

		"SS":
			rank.frame = 0

		"S":
			rank.frame = 1

		"A":
			rank.frame = 2

		"B":
			rank.frame = 3

		"C":
			rank.frame = 4

		"D":
			rank.frame = 5

		_:
			rank.frame= 5

func animar_numero(label: RichTextLabel, valor_final: int, sufixo := ""):

	label.text = "0" + sufixo

	var tween = create_tween()

	tween.tween_method(
		func(valor):
			label.text = str(int(valor)) + sufixo,
		0,
		valor_final,
		2
	)
	
	await tween.finished
	
func animar_porcentagem(label: RichTextLabel, valor_final: float):

	label.text = "0.00%"

	var tween = create_tween()

	tween.tween_method(
		func(valor):
			label.text = "%.2f%%" % valor,
		0.0,
		valor_final,
		2
	)
	await tween.finished
	
func animar_notes(acertos, total):

	var tween = create_tween()

	var valor := 0

	tween.tween_method(
		func(v):
			valor = int(v)
			notes.text = "%d / %d" % [valor, total],
		0,
		acertos,
		2
	)
	await tween.finished
	
func animar_hit_rate(hit_rate):

	var tween = create_tween()

	tween.tween_method(
		func(v):
			notes.text = "%s (%.1f%%)" % [
				resultado["notes_string"],
				v
			],
		0.0,
		hit_rate,
		1.4
	)
	await tween.finished
