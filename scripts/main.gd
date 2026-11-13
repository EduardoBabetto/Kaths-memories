extends Node2D

@onready var dialog_box = $dialog_box
@onready var sd = $SoundTrack
var dialog_data = [
	{
		"name": "Kath",
		"text": "Acordei tão assustada....",
		"text_color": Color(1, 0, 0),
		"bg_color": Color(0, 0, 0, 0.8),
		"border_color": Color(0.0, 1.643, 0.339, 1.0),
		"animation": "Kath",
		"side": Side.SIDE_LEFT
	},
	{
		"name": "Kath",
		"text": "Que até troquei de roupa",
		"text_color": Color(1, 0, 0),
		"bg_color": Color(0, 0, 0, 0.8),
		"border_color": Color(0.0, 1.643, 0.339, 1.0),
		"animation": "Kath",
		"side": Side.SIDE_LEFT
	},
	{
		"name": "Kath",
		"text": "Serà que eu ja posso voltar a dormir?",
		"text_color": Color(1, 0, 0),
		"bg_color": Color(0, 0, 0, 0.8),
		"border_color": Color(0.0, 1.643, 0.339, 1.0),
		"animation": "Kath", 
		"side": Side.SIDE_LEFT
	}
]

func _ready():
	sd.play()
	dialog_box.start_dialog(dialog_data)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if dialog_box.is_active:
			dialog_box.next_line()
