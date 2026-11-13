extends Node
class_name GameStateController

signal game_started
signal game_overed
signal game_won
signal game_closed

var main

enum Estado{

	MENU,

	SONG_SELECT,

	PLAYING,

	RESULT
}

var estado := Estado.MENU

var beatmap
var arrows
var score
var life
var effects
var decoration
var ui

func initialize(main_node):

	main = main_node

	beatmap = main.beatmap
	arrows = main.arrows
	score = main.score
	life = main.vidas
	effects = main.effects
	decoration = main.decoracoes
	ui = main.ui

func mudar_estado(novo_estado):

	if estado == novo_estado:
		return

	estado = novo_estado

	match estado:

		Estado.MENU:
			
			ui.mostrar_menu()

			main.song_select.fechar()

			main.result.fechar()

		Estado.SONG_SELECT:

			ui.esconder_menu()

			main.song_select.abrir()

			main.result.fechar()

		Estado.PLAYING:

			main.song_select.fechar()

			main.result.fechar()

			ui.mostrar_jogo()

		Estado.RESULT:
			main.result.abrir()
			
func _process(delta):

	if !esta_jogando():
		return

	verificar_fim()
	
func game_over():

	if !esta_jogando():
		return

	beatmap.parar()

	arrows.limpar()

	effects.resetar()

	decoration.resetar()
	
	mudar_estado(Estado.RESULT)

	emit_signal("game_overed")
	
func verificar_fim():

	if !beatmap.esta_tocando() \
	and beatmap.terminou() \
	and arrows.sem_setas():

		vitoria()
		
func abrir():

	mudar_estado(Estado.MENU)
	
func fechar():

	beatmap.parar()

	arrows.resetar()

	effects.resetar()

	decoration.resetar()

	mudar_estado(Estado.MENU)

	emit_signal("game_closed")
	
func vitoria():

	if !esta_jogando():
		return

	mudar_estado(Estado.RESULT)

	beatmap.parar()

	emit_signal("game_won")
	
func iniciar_partida():

	await main.song_select.fechar()

	await main.result.fechar()

	mudar_estado(Estado.PLAYING)

	score.resetar()

	life.resetar()

	arrows.resetar()

	decoration.resetar()

	effects.resetar()

	beatmap.resetar()

	ui.mostrar_jogo()

	beatmap.tocar()

	emit_signal("game_started")
	
func on_beatmap_loaded(data):

	score.score_multiplier = beatmap.get_score_multiplier()

	arrows.velocidade = beatmap.get_scroll_speed()
	
func esta_jogando():

	return estado == Estado.PLAYING

func reiniciar_partida():

	beatmap.recarregar_musica()

	iniciar_partida()
