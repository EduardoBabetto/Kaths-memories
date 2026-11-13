extends Button

signal clicked(indice)

var indice := -1

var dados := {}

@onready var song_name = $MarginContainer/PanelContainer/VBoxContainer/SongName
@onready var artist = $MarginContainer/PanelContainer/VBoxContainer/Artist
@onready var difficulty = $MarginContainer/PanelContainer/VBoxContainer/Difficulty


func _ready():

	pressed.connect(_on_pressed)


func setup(data, index):

	dados = data
	indice = index

	song_name.text = data.get("title", "")

	artist.text = data.get("artist", "")

	difficulty.text = data.get("difficulty", "")
	


func _on_pressed():

	emit_signal("clicked", indice)
	
func set_selected(value):

	if value:
		modulate = Color(1,1,1)
	else:
		modulate = Color(0.75,0.75,0.75)
