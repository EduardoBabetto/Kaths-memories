extends Node2D

var notes = []

var audio_path := ""
var beatmap_folder := ""
var cover_path := ""

var beatmap := {}

var recording := false

@onready var audio = $AudioStreamPlayer

@onready var file_dialog = $FileDialog
@onready var cover_dialog = $CoverDialog

# Música

@onready var nome = $CanvasLayer/VBoxContainer/Musicas/Nome
@onready var artista = $CanvasLayer/VBoxContainer/Musicas/Artista
@onready var dificuldade = $CanvasLayer/VBoxContainer/Musicas/Dificuldade
@onready var album = $CanvasLayer/VBoxContainer/Musicas/Album
@onready var creator = $CanvasLayer/VBoxContainer/Musicas/Creator
@onready var version = $CanvasLayer/VBoxContainer/Musicas/Version

# Config

@onready var bpm = $CanvasLayer/VBoxContainer/Config/BPM
@onready var offset = $CanvasLayer/VBoxContainer/Config/Offset
@onready var tempo_queda = $"CanvasLayer/VBoxContainer/Config/TempoQueda"
@onready var velocidade = $CanvasLayer/VBoxContainer/Config/Velocidade
@onready var multiplicador = $CanvasLayer/VBoxContainer/Config/Multiplicador

# Audio

@onready var label_musica = $CanvasLayer/VBoxContainer/Audio/LabelMusica
@onready var btn_play = $CanvasLayer/VBoxContainer/Audio/Play
@onready var btn_pause = $CanvasLayer/VBoxContainer/Audio/Pause
@onready var btn_mp3 = $CanvasLayer/VBoxContainer/Audio/mp3

# Beatmap

@onready var quantidade = $CanvasLayer/VBoxContainer/Beatmap/QuantidadeNotas
@onready var tempo = $CanvasLayer/VBoxContainer/Beatmap/LabelTempo
@onready var CoverSelect = $CanvasLayer/VBoxContainer/Beatmap/CoverSelect

# Salvar

@onready var salvar = $CanvasLayer/VBoxContainer/Beatmap/Salvar


func _ready():

	btn_play.pressed.connect(_play)

	btn_pause.pressed.connect(_pause)
	
	btn_mp3.pressed.connect(_abrir_file_dialog)

	salvar.pressed.connect(_salvar)

	file_dialog.file_selected.connect(_arquivo_escolhido)
	
	CoverSelect.pressed.connect(_abrir_Cover_dialog)

	cover_dialog.file_selected.connect(_cover_escolhida)

	quantidade.text = "Notas: 0"
	
func _abrir_file_dialog():

	file_dialog.popup_centered()
	
func _cover_escolhida(path):

	cover_path = path

	CoverSelect.text = path.get_file()
	
func _abrir_Cover_dialog():

	cover_dialog.popup_centered()
	
func _arquivo_escolhido(path):

	audio_path = path

	audio.stream = load(path)

	label_musica.text = path.get_file()
	
func _play():

	if audio.stream == null:
		return

	audio.play()

	recording = true
	
func _pause():

	audio.stream_paused = !audio.stream_paused

func _process(delta):

	if audio.playing:

		tempo.text = "Tempo: %.3f" % audio.get_playback_position()
		
func _input(event):

	if !recording:
		return

	if event.is_action_pressed("ui_left"):
		registrar_nota(0)

	if event.is_action_pressed("ui_up"):
		registrar_nota(1)

	if event.is_action_pressed("ui_down"):
		registrar_nota(2)

	if event.is_action_pressed("ui_right"):
		registrar_nota(3)
		
func registrar_nota(lane):

	notes.append({

		"time": audio.get_playback_position(),

		"lane": lane,

		"type":"tap"

	})

	quantidade.text = "Notas: " + str(notes.size())
	
func _salvar():

	var pasta = "res://beatmaps/" + nome.text.strip_edges()

	if !DirAccess.dir_exists_absolute(pasta):
		DirAccess.make_dir_recursive_absolute(pasta)

	var audio_destino = pasta + "/music." + audio_path.get_extension()

	var origem = ProjectSettings.globalize_path(audio_path)
	var destino = ProjectSettings.globalize_path(audio_destino)

	DirAccess.copy_absolute(origem, destino)
	
	var nome_cover := ""

	if cover_path != "":

		nome_cover = "cover." + cover_path.get_extension()

		var cover_destino = pasta + "/" + nome_cover

		var origem_cover = ProjectSettings.globalize_path(cover_path)
		var destino_cover = ProjectSettings.globalize_path(cover_destino)

		DirAccess.copy_absolute(origem_cover, destino_cover)

	beatmap = {

	"title": nome.text,

	"artist": artista.text,

	"album": album.text,

	"creator": creator.text,

	"version": version.text,

	"difficulty": dificuldade.get_item_text(dificuldade.selected),

	"cover": "",

	"audio": "music." + audio_path.get_extension(),

	"preview_start": 15.0,

	"preview_duration": 12.0,

	"bpm": bpm.value,

	"offset": offset.value,

	"scroll_time": tempo_queda.value,

	"scroll_speed": velocidade.value,

	"score_multiplier": multiplicador.value,

	"notes": notes

}

	var texto = JSON.stringify(beatmap, "\t")

	var file = FileAccess.open(
		pasta + "/beatmap.json",
		FileAccess.WRITE
	)

	file.store_string(texto)

	file.close()

	print("Beatmap salvo!")
