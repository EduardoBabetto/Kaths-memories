extends Node
class_name BeatmapController

signal beatmap_loaded(data)
signal spawn_note(lane)
signal musica_finalizada
signal musica_selecionada(data)

var tempo_de_queda := 2.0

var beatmap_data = {}

var musicas = []

var notas_json = []

var indice_nota = 0

var offset :=0.0

var main

var audio

var musica_atual = -1

func initialize(main_node):

	main = main_node

	audio = main.get_node("AudioStreamPlayer")

@export_file("*.json")
var beatmap_path : String

func scan_beatmaps():

	musicas.clear()

	var dir = DirAccess.open("res://beatmaps")
	
	if dir == null:
		print("Pasta beatmaps não encontrada.")
		return
	print("Pasta beatmaps encontrada.")

	dir.list_dir_begin()

	while true:

		var pasta = dir.get_next()
		

		if pasta == "":
			break

		if !dir.current_is_dir():
			continue

		var caminho = "res://beatmaps/%s/beatmap.json" % pasta
		

		if !FileAccess.file_exists(caminho):
			print("Beatmap inexistente:", caminho)
			continue

		var data = BeatmapLoader.load_beatmap(caminho)
		

		if data.is_empty():
			continue

		musicas.append({

	"title": data["title"],

	"artist": data.get("artist",""),

	"album": data.get("album",""),

	"creator": data.get("creator",""),

	"version": data.get("version",""),

	"difficulty": data.get("difficulty",""),

	"cover": caminho.get_base_dir() + "/" + data.get("cover",""),

	"audio": caminho.get_base_dir() + "/" + data.get("audio",""),

	"preview_start": data.get("preview_start",0.0),

	"preview_duration": data.get("preview_duration",12.0),

	"bpm": data.get("bpm",120),

	"path": caminho

})
	dir.list_dir_end()
	
	musicas.sort_custom(_sort_musicas)
	

func _sort_musicas(a, b):

	return a["title"] < b["title"]

func get_musicas():

	return musicas

func get_musica(indice):

	if indice < 0:
		return {}

	if indice >= musicas.size():
		return {}

	return musicas[indice]

func selecionar(indice):

	if indice < 0:
		return

	if indice >= musicas.size():
		return

	musica_atual = indice

	var data = carregar_beatmap(
			musicas[indice]["path"]
	)

	emit_signal("musica_selecionada", data)
	
func carregar_beatmap(path):

	beatmap_data = BeatmapLoader.load_beatmap(path)

	if beatmap_data.is_empty():
		return {}

	var pasta = path.get_base_dir()

	audio.stream = load(
		pasta + "/" + beatmap_data["audio"]
	)

	notas_json = beatmap_data.get("notes", [])

	indice_nota = 0

	tempo_de_queda = beatmap_data.get("scroll_time",2.0)

	offset = beatmap_data.get("offset",0.0)

	emit_signal("beatmap_loaded",beatmap_data)

	return beatmap_data

func get_song_time():

	var tempo = audio.get_playback_position()
	tempo += AudioServer.get_time_since_last_mix()
	tempo -= AudioServer.get_output_latency()

	return tempo

func atualizar_beatmap():

	if indice_nota >= notas_json.size():
		return

	var tempo = get_song_time() + offset

	while indice_nota < notas_json.size():

		var nota = notas_json[indice_nota]

		if tempo >= nota["time"] - tempo_de_queda:

			emit_signal("spawn_note", nota["lane"])

			indice_nota += 1

		else:
			break
			
func tocar():
	if audio.stream == null:
		return

	audio.play()

func parar():
	audio.stop()

func _process(delta):
	
	if !main.game.esta_jogando():
		return

	if audio.stream == null:
		return

	atualizar_beatmap()

	if !audio.playing and indice_nota >= notas_json.size():
		emit_signal("musica_finalizada")
		
func resetar():

	indice_nota = 0

	audio.stop()

	audio.seek(0)

func get_scroll_speed():

	return beatmap_data.get("scroll_speed",85.0)

func get_score_multiplier():

	return beatmap_data.get("score_multiplier",1.0)
	
func terminou():

	return indice_nota >= notas_json.size()

func esta_tocando():

	return audio.playing
	
func voltar_inicio():

	audio.seek(0)

func get_musica_selecionada():
	if musica_atual == -1:
		return {}
	return musicas[musica_atual]

func quantidade_musicas():

	return musicas.size()
	
func recarregar_musica():

	if musica_atual == -1:
		return

	carregar_beatmap(
		musicas[musica_atual]["path"]
	)
