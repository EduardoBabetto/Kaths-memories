extends Node
class_name ArrowController

signal note_hit(rating, lane)
signal note_passed(tecla)
signal wrong_input(tecla)

var main

func initialize(main_node):

	main = main_node
	spawnadas = main.get_node("CanvasLayer/Game/spawnadas")
	hit_markers = {
		"ui_left": main.get_node("CanvasLayer/Game/setasVazias/SetaAvazia"),
		"ui_right": main.get_node("CanvasLayer/Game/setasVazias/SetaDvazia"),
		"ui_up": main.get_node("CanvasLayer/Game/setasVazias/SetaWvazia"),
		"ui_down": main.get_node("CanvasLayer/Game/setasVazias/SetaSvazia"),
	}
	
	seta_spawns = [
		main.get_node("CanvasLayer/Game/setas/SetaA"),
		main.get_node("CanvasLayer/Game/setas/SetaW"),
		main.get_node("CanvasLayer/Game/setas/SetaS"),
		main.get_node("CanvasLayer/Game/setas/SetaD"),
	]
	velocidade = 85.0
	setas_caindo.clear()

var hit_markers = {}

var spawnadas : Node

var seta_spawns = []

var velocidade := 85.0

var hitbox_tamanho := 60.0

# lane por tecla
var tecla_lane = {
	"ui_left": 0,
	"ui_up": 1,
	"ui_down": 2,
	"ui_right": 3
}

var setas_caindo = []

func _process(delta):

	for seta_data in setas_caindo.duplicate():

		var seta = seta_data["node"]

		if !is_instance_valid(seta):
			continue

		var tecla = seta_data["tecla"]
		var marker = hit_markers[tecla]

		seta.position.y += velocidade * delta

		if seta.position.y >= marker.position.y + hitbox_tamanho:
			seta.queue_free()
			setas_caindo.erase(seta_data)
			emit_signal("note_passed", tecla)
		
func spawn_seta_lane(lane):

	lane = int(lane)
	var original = seta_spawns[lane]
	var nova_seta = original.duplicate()

	nova_seta.position = original.position
	nova_seta.visible = true
	nova_seta.frame = 0
	nova_seta.scale = original.scale
	nova_seta.rotation = original.rotation

	spawnadas.add_child(nova_seta)

	const TECLAS = [
		"ui_left",
		"ui_up",
		"ui_down",
		"ui_right"
	]

	var tecla = TECLAS[lane]
	
	

	setas_caindo.append({
		"node": nova_seta,
		"tecla": tecla
	})

func check_hit(tecla, seta_visual):

	seta_visual.frame = 1

	await get_tree().create_timer(0.1).timeout

	seta_visual.frame = 0

	var marker = hit_markers[tecla]
	

	var melhor_seta = null
	var menor_distancia = 99999.0

	for seta_data in setas_caindo:
		var seta = seta_data["node"]

		if !is_instance_valid(seta):
			continue

		if seta_data["tecla"] != tecla:
			continue

		var distancia = abs(seta.position.y - marker.position.y)

		if distancia < menor_distancia:
			menor_distancia = distancia
			melhor_seta = seta_data
			
	if melhor_seta == null:
		emit_signal("wrong_input", tecla)
		return
		
	if menor_distancia > hitbox_tamanho:
		emit_signal("note_passed", tecla)
		return
	
	if menor_distancia <= hitbox_tamanho:
	
		var rating = get_hit_rating(menor_distancia)
		var lane = tecla_lane[tecla]
		
		emit_signal("note_hit", rating, lane)

		var seta = melhor_seta["node"]

		seta.queue_free()

		setas_caindo.erase(melhor_seta)

func get_hit_rating(distancia):

	if distancia <= 8:
		return "perfect"

	elif distancia <= 20:
		return "good"

	elif distancia <= 35:
		return "late"

	else:
		return "miss"

func tecla_from_lane(lane):

	match lane:
		0:
			return "ui_left"

		1:
			return "ui_up"

		2:
			return "ui_down"

		3:
			return "ui_right"

	return "ui_left"

func limpar():

	for seta_data in setas_caindo:

		if is_instance_valid(seta_data["node"]):
			seta_data["node"].queue_free()

	setas_caindo.clear()

func resetar():

	limpar()

	velocidade = 85.0
	
func sem_setas():

	return setas_caindo.is_empty()

func handle_input(event):

	if event.is_action_pressed("ui_left") and !event.echo:
		check_hit("ui_left", main.seta_a)

	if event.is_action_pressed("ui_up") and !event.echo:
		check_hit("ui_up", main.seta_w)

	if event.is_action_pressed("ui_down") and !event.echo:
		check_hit("ui_down", main.seta_s)

	if event.is_action_pressed("ui_right") and !event.echo:
		check_hit("ui_right", main.seta_d)

func set_velocidade(valor):

	velocidade = valor
	
func quantidade_setas():

	return setas_caindo.size()

func parar():

	limpar()
