extends Node
class_name EffectController

var hit_effects = []

var hit_markers = {}

var effects_ativos = []

var main

func initialize(main_node):

	main = main_node

	hit_effects = [
		main.get_node("CanvasLayer/Game/effects/effectsAzul"),
		main.get_node("CanvasLayer/Game/effects/effectsVermelho"),
		main.get_node("CanvasLayer/Game/effects/effectsAmarelo"),
		main.get_node("CanvasLayer/Game/effects/effectsVerde")
	]

	hit_markers = {
		"ui_left": main.get_node("CanvasLayer/Game/setasVazias/SetaAvazia"),
		"ui_up": main.get_node("CanvasLayer/Game/setasVazias/SetaWvazia"),
		"ui_down": main.get_node("CanvasLayer/Game/setasVazias/SetaSvazia"),
		"ui_right": main.get_node("CanvasLayer/Game/setasVazias/SetaDvazia")
	}
	

func _process(delta):

	if !main.game.esta_jogando():
		return

	for effect_data in effects_ativos.duplicate():

		var effect = effect_data["node"]

		effect.position.y -= 40 * delta

		effect.modulate.a -= delta * 2

		if effect.modulate.a <= 0:

			effect.visible = false
			effect.modulate.a = 1.0
			effect.position = effect_data["original"]

			effects_ativos.erase(effect_data)

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

func play_hit_effect(lane, rating):

	var effect = hit_effects[lane]

	match rating:
		"perfect":
			effect.frame = 0

		"good":
			effect.frame = 1

		"late":
			effect.frame = 2

		"miss":
			effect.frame = 3

	effect.visible = true
	effect.modulate.a = 1.0

	var tecla = tecla_from_lane(lane)

	effect.position = hit_markers[tecla].position + Vector2(0, -20)

	effects_ativos.append({
		"node": effect,
		"original": effect.position
	})
func resetar():

	for effect in hit_effects:

		effect.visible = false
		effect.modulate.a = 1.0

	effects_ativos.clear()

func on_note_hit(rating, lane):
	play_hit_effect(lane, rating)

func limpar():

	resetar()
