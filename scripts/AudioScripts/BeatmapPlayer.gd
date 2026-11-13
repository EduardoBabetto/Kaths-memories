extends Node

var notas=[]

var indice=0

@onready var song=$"../SongManager"

@onready var spawner=$"../PatternSpawner"

func load(array):

	notas=array

	indice=0

func _process(delta):

	if indice>=notas.size():
		return

	var tempo=song.get_time()

	while indice<notas.size():

		var nota=notas[indice]

		if tempo>=nota.time:

			spawner.spawn(nota.lane)

			indice+=1

		else:
			break
