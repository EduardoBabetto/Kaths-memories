extends Node2D

signal song_selected(indice)
signal back_pressed
signal random_pressed

var main

var beatmap

var musicas = []

var indice_atual := 0

var tela
var lista
var left_panel
var cover
var song_name
var artist
var album
var creator
var difficulty
var bpm
var preview_status
var play_button
var back_button
var random_button
var animation

func initialize(main_node):

	
	main = main_node

	beatmap = main.beatmap

	tela = main.get_node("CanvasLayer/SongSelect")
	tela.hide()

	lista = main.get_node("CanvasLayer/SongSelect/MarginContainer/HBoxContainer/RightPanel/VBoxContainer/ScrollContainer/VBoxContainer")
	
	left_panel = main.get_node("CanvasLayer/SongSelect/MarginContainer/HBoxContainer/LeftPanel")
	
	cover = main.get_node("CanvasLayer/SongSelect/MarginContainer/HBoxContainer/LeftPanel/VBoxContainer/Cover")
	
	song_name = main.get_node("CanvasLayer/SongSelect/MarginContainer/HBoxContainer/LeftPanel/VBoxContainer/SongInfo/SongName")
	
	artist = main.get_node("CanvasLayer/SongSelect/MarginContainer/HBoxContainer/LeftPanel/VBoxContainer/SongInfo/Artist")
	
	album = main.get_node("CanvasLayer/SongSelect/MarginContainer/HBoxContainer/LeftPanel/VBoxContainer/SongInfo/Album")
	
	creator = main.get_node("CanvasLayer/SongSelect/MarginContainer/HBoxContainer/LeftPanel/VBoxContainer/SongInfo/Creator")
	
	difficulty = main.get_node("CanvasLayer/SongSelect/MarginContainer/HBoxContainer/LeftPanel/VBoxContainer/SongInfo/Difficulty")
	
	bpm = main.get_node("CanvasLayer/SongSelect/MarginContainer/HBoxContainer/LeftPanel/VBoxContainer/SongInfo/BPM")
	
	preview_status = main.get_node("CanvasLayer/SongSelect/MarginContainer/HBoxContainer/LeftPanel/VBoxContainer/SongInfo/PreviewStatus")
	
	play_button = main.get_node("CanvasLayer/SongSelect/MarginContainer/HBoxContainer/RightPanel/VBoxContainer/HBoxContainer/PlayButton")
	
	back_button = main.get_node("CanvasLayer/SongSelect/MarginContainer/HBoxContainer/RightPanel/VBoxContainer/HBoxContainer/BackButton")
	
	random_button = main.get_node("CanvasLayer/SongSelect/MarginContainer/HBoxContainer/RightPanel/VBoxContainer/HBoxContainer/RandomButton")
	
	animation = main.get_node("CanvasLayer/SongSelect/AnimationPlayer")
	
	setup()
	
	
func setup():
	play_button.pressed.connect(_on_play)
	back_button.pressed.connect(_on_back)
	random_button.pressed.connect(_on_random)
	

func abrir():

	main.ui.esconder_menu()

	tela.show()

	if animation.has_animation("open"):
		animation.play("open")

	beatmap.scan_beatmaps()

	musicas = beatmap.get_musicas()

	popular_lista()

	selecionar(0)
	

func fechar():

	if animation.has_animation("close"):

		animation.play("close")

		await animation.animation_finished

	tela.hide()
	

func popular_lista():

	for child in lista.get_children():
		child.queue_free()

	var cena = preload("res://scenes/ui/song_item.tscn")

	for i in range(musicas.size()):

		var item = cena.instantiate()

		lista.add_child(item)
		
		item.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		item.setup(musicas[i], i)

		item.clicked.connect(selecionar)
		
func atualizar_lista_visual():

	for i in lista.get_child_count():

		var item = lista.get_child(i)

		item.set_selected(i == indice_atual)
	
func selecionar(indice):

	if musicas.is_empty():
		return

	indice = clamp(indice,0,musicas.size()-1)

	indice_atual = indice

	atualizar_painel()

	atualizar_lista_visual()

	tocar_preview()
	
func atualizar_painel():
	
	var musica = musicas[indice_atual]
	
	song_name.text = musica["title"]
	artist.text = musica["artist"]
	album.text = musica["album"]
	creator.text = musica["creator"]
	difficulty.text = musica["difficulty"]
	bpm.text = str(musica["bpm"])
	
	if musica["cover"] != "":
		cover.texture = load(musica["cover"])
	else:
		cover.texture = null
	
func _on_play():
	fechar()
	emit_signal("song_selected",indice_atual)
	
func _on_back():

	emit_signal("back_pressed")

func _on_random():
	if musicas.is_empty():
		return
		
	selecionar(
	randi()%musicas.size())
	
func tocar_preview():
	preview_status.text = "Loading..."
	
func _on_pressed():
	print("Clique:", indice_atual)
	emit_signal("clicked", indice_atual)

	
