extends Node2D

signal closed 

@onready var beatmap = $Controllers/BeatmapController
@onready var arrows = $Controllers/ArrowController
@onready var score = $Controllers/ScoreController
@onready var vidas = $Controllers/LifeController
@onready var effects = $Controllers/EffectController
@onready var decoracoes = $Controllers/DecorationController
@onready var ui = $Controllers/UIController
@onready var game = $Controllers/GameStateController
@onready var song_select = $Controllers/SongSelectController
@onready var result = $Controllers/ResultController

# =========================
# MENU
# =========================
@onready var menu = $CanvasLayer/Menu/CanvasLayer
@onready var start_btn = $CanvasLayer/Menu/CanvasLayer/HBoxContainer/VBoxContainer/Start_btn
@onready var quit_btn = $CanvasLayer/Menu/CanvasLayer/HBoxContainer/VBoxContainer/Quit_Btn

@onready var score_label = $CanvasLayer/Game/Score
@onready var combo_label = $CanvasLayer/Game/Combo

# ÁREA DE ACERTO
@onready var hit_markers = {
	"ui_left": $CanvasLayer/Game/setasVazias/SetaAvazia,
	"ui_up": $CanvasLayer/Game/setasVazias/SetaWvazia,
	"ui_down": $CanvasLayer/Game/setasVazias/SetaSvazia,
	"ui_right": $CanvasLayer/Game/setasVazias/SetaDvazia
}

# effects ativos
var effects_ativos = []


# =========================
# SETAS
# =========================
@onready var seta_a = $CanvasLayer/Game/setas/SetaA
@onready var seta_w = $CanvasLayer/Game/setas/SetaW
@onready var seta_s = $CanvasLayer/Game/setas/SetaS
@onready var seta_d = $CanvasLayer/Game/setas/SetaD


@onready var sd= $SoundTrack

func _ready():
	
	randomize()
	
	sd.play()
	
	result.initialize(self)
	
	song_select.initialize(self)

	beatmap.initialize(self)

	arrows.initialize(self)

	score.initialize(self)

	vidas.initialize(self)

	effects.initialize(self)

	decoracoes.initialize(self)

	ui.initialize(self)

	game.initialize(self)
	
		# Conexões
	arrows.note_hit.connect(score.on_note_hit)
	arrows.note_hit.connect(effects.on_note_hit)
	arrows.note_passed.connect(score.on_note_passed)
	arrows.note_passed.connect(vidas.on_note_passed)
	arrows.wrong_input.connect(score.on_wrong_input)

	ui.quit_pressed.connect(game.fechar)
	ui.start_pressed.connect(_on_start_pressed)
	
	score.score_changed.connect(ui.atualizar_score)
	
	beatmap.spawn_note.connect(arrows.spawn_seta_lane)
	beatmap.musica_finalizada.connect(game.verificar_fim)
	beatmap.beatmap_loaded.connect(game.on_beatmap_loaded)
	beatmap.spawn_note.connect(decoracoes._on_spawn_note)
	
	vidas.game_over.connect(game.game_over)
	vidas.life_changed.connect(ui.atualizar_vidas)

	game.game_started.connect(ui.mostrar_jogo)
	game.game_started.connect(beatmap.tocar)
	game.game_overed.connect(beatmap.parar)
	game.game_won.connect(beatmap.parar)
	game.game_started.connect(decoracoes.resetar)
	game.game_started.connect(arrows.resetar)
	game.game_started.connect(effects.resetar)
	game.game_started.connect(score.resetar)
	game.game_started.connect(vidas.resetar)
	game.game_closed.connect(fechar)
	game.game_started.connect(song_select.fechar)
	
	song_select.song_selected.connect(beatmap.selecionar)
	song_select.back_pressed.connect(_on_song_select_back)
	song_select.song_selected.connect(_on_song_selected)
	
	result.song_select_pressed.connect(_on_result_song_select)
	result.retry_pressed.connect(_on_result_retry)
	result.menu_pressed.connect(_on_result_menu)
	result.enter_result.connect(_on_result_enter)


func _on_song_selected(indice):

	beatmap.selecionar(indice)
	sd.stop()

	game.iniciar_partida()

func abrir():
	show()
	game.abrir()
	
func fechar():
	emit_signal("closed")
	
func _input(event):

	if !game.esta_jogando():
		return

	arrows.handle_input(event)
	
func _on_result_song_select():
	game.mudar_estado(game.Estado.SONG_SELECT)
	sd.play()

func _on_result_retry():
	game.reiniciar_partida()
	
func _on_result_menu():
	game.mudar_estado(game.Estado.MENU)
	sd.play()
	
func _on_result_enter():
	sd.play()
	
func _on_start_pressed():

	game.mudar_estado(game.Estado.SONG_SELECT)

func _on_song_select_back():
	game.mudar_estado(game.Estado.MENU)
