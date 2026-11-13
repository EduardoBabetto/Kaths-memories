extends Node2D


enum TipoInteracao {
	NORMAL,
	VELA,
	BOLO,
	EVE
}


@export var tipo_interacao: TipoInteracao = TipoInteracao.NORMAL

@export var dialog_data = []

# Objeto que receberá a ação especial
#
# Vela -> arraste a Vela aqui
# Bolo -> arraste o Bolo aqui
# Eve  -> arraste a Eve aqui

@export var alvo: Node

# Usado somente pelo Bolo
# Arraste a Vela da cena aqui
@export var vela_para_sumir: Node2D


var player_inside := false
var ativo := true

@onready var interact_icon = %AnimatedSprite2D
@onready var dialog_box = get_tree().get_first_node_in_group("dialog")

var time := 0.0


func _ready():

	interact_icon.hide()


func _on_area_2d_body_entered(body):

	if not ativo:
		return

	if body.is_in_group("player"):
		player_inside = true
		interact_icon.show()


func _on_area_2d_body_exited(body):

	if body.is_in_group("player"):
		player_inside = false
		interact_icon.hide()


func _process(delta):

	time += delta

	interact_icon.position.y = -40 + sin(time * 3) * 5

	if not ativo:
		return

	if player_inside and Input.is_action_just_pressed("interact"):

		if dialog_box.is_active or dialog_box.input_locked:
			return

		interagir()


# =========================================================
# ATIVAR / DESATIVAR OBJETO
# =========================================================

func ativar(valor: bool):

	ativo = valor

	if not ativo:
		player_inside = false
		interact_icon.hide()


# =========================================================
# INTERAÇÃO
# =========================================================

func interagir():

	if not ativo:
		return

	match tipo_interacao:

		TipoInteracao.NORMAL:
			interacao_normal()

		TipoInteracao.VELA:
			interacao_vela()

		TipoInteracao.BOLO:
			interacao_bolo()

		TipoInteracao.EVE:
			interacao_eve()


# =========================================================
# NORMAL
# =========================================================

func interacao_normal():

	dialog_box.start_dialog(dialog_data)

	interact_icon.hide()


# =========================================================
# VELA
# =========================================================

func interacao_vela():

	if alvo == null:

		push_error(
			"ObjetoInterativoVela não possui um alvo definido."
		)

		return


	if not alvo.has_method("apagar_vela"):

		push_error(
			"O alvo da vela não possui o método apagar_vela()."
		)

		return


	# Esconde imediatamente o ícone
	interact_icon.hide()

	# Impede novas interações
	ativo = false
	player_inside = false

	# Apaga a vela
	await alvo.apagar_vela()

	# Garante que o objeto interativo continue desativado
	ativar(false)


# =========================================================
# BOLO
# =========================================================

func interacao_bolo():

	if alvo == null:

		push_error(
			"ObjetoInterativoBolo não possui um alvo definido."
		)

		return


	if not alvo.has_method("interagir"):

		push_error(
			"O alvo do bolo não possui o método interagir()."
		)

		return


	interact_icon.hide()


	# -------------------------------------------------
	# PRIMEIRA INTERAÇÃO
	# -------------------------------------------------

	var primeira_interacao = false

	if alvo.has_method("quantidade_interacoes"):

		primeira_interacao = (
			alvo.quantidade_interacoes() == 0
		)


	# -------------------------------------------------
	# Faz o bolo ser usado
	# -------------------------------------------------

	var dados_dialogo = alvo.interagir()


	# -------------------------------------------------
	# PRIMEIRA INTERAÇÃO:
	# VELA SOME
	# -------------------------------------------------

	if primeira_interacao:

		if vela_para_sumir != null:

			vela_para_sumir.hide()


	# -------------------------------------------------
	# DIÁLOGO
	# -------------------------------------------------

	if dados_dialogo != null:

		dialog_box.start_dialog(dados_dialogo)

		await dialog_box.dialog_finished


	# -------------------------------------------------
	# VERIFICA SE O BOLO AINDA PODE SER USADO
	# -------------------------------------------------

	if alvo.has_method("pode_interagir"):

		if alvo.pode_interagir():

			if player_inside:
				interact_icon.show()

		else:

			# Bolo terminou todas as interações
			ativar(false)

	else:

		# Segurança
		ativar(false)


# =========================================================
# EVE
# =========================================================

func interacao_eve():

	if alvo == null:

		push_error(
			"ObjetoInterativoEve não possui um alvo definido."
		)

		return


	interact_icon.hide()

	ativo = false
	player_inside = false


	if alvo.has_method("interagir"):

		await alvo.interagir()


	# Eve continua como interação única
	ativar(true)
