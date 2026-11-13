extends Node2D


@onready var sprite: Sprite2D = $Sprite2D
@onready var audio = $Comendo

var interacoes := 0
var max_interacoes := 5


var dialogos = [

	[
		{
			"name": "Kath",
			"text": "Esse bolo é a minha cara.",
			"text_color": Color(1, 0, 0),
			"bg_color": Color(0, 0, 0, 0.8),
			"border_color": Color(0.0, 1.643, 0.339, 1.0),
			"animation": "Kath", 
			"side": Side.SIDE_LEFT
		},
	],

	[
		{
			"name": "Kath",
			"text": "Tá muito gostosoo!!",
			"text_color": Color(1, 0, 0),
			"bg_color": Color(0, 0, 0, 0.8),
			"border_color": Color(0.0, 1.643, 0.339, 1.0),
			"animation": "Kath", 
			"side": Side.SIDE_LEFT
		},
	],

	[
		{
			"name": "Kath",
			"text": "Vo comer tudo sozinho fodase",
			"text_color": Color(1, 0, 0),
			"bg_color": Color(0, 0, 0, 0.8),
			"border_color": Color(0.0, 1.643, 0.339, 1.0),
			"animation": "Kath", 
			"side": Side.SIDE_LEFT
		},
		{
			"name": "Eddw",
			"text": "Deixa pra gente também?",
			"text_color": Color(0.0, 0.655, 0.0, 1.0),
			"bg_color": Color(0, 0, 0, 0.8),
			"border_color": Color(1.643, 0.0, 0.0, 1.0),
			"animation": "Eddw", 
			"side": Side.SIDE_RIGHT
		},
		{
			"name": "Kath",
			"text": "MÃO!",
			"text_color": Color(1, 0, 0),
			"bg_color": Color(0, 0, 0, 0.8),
			"border_color": Color(0.0, 1.643, 0.339, 1.0),
			"animation": "Kath", 
			"side": Side.SIDE_LEFT
		},
	],

	[
		{
			"name": "Kath",
			"text": "Ai eu to com dor de barriga...",
			"text_color": Color(1, 0, 0),
			"bg_color": Color(0, 0, 0, 0.8),
			"border_color": Color(0.0, 1.643, 0.339, 1.0),
			"animation": "Kath", 
			"side": Side.SIDE_LEFT
		},
		{
			"name": "Mamae",
			"text": "Melhor parar de comer.",
			"text_color": Color(0.0, 0.632, 0.451, 1.0),
			"bg_color": Color(0, 0, 0, 0.8),
			"border_color": Color(1.643, 0.551, 0.0, 1.0),
			"animation": "Mamae", 
			"side": Side.SIDE_RIGHT
		},
		{
			"name": "Eddw",
			"text": "Vou pegar o meu pelo menos...",
			"text_color": Color(0.0, 1.0, 0.0, 1.0),
			"bg_color": Color(0, 0, 0, 0.8),
			"border_color": Color(1.643, 1.643, 0.0, 1.0),
			"animation": "Eddw", 
			"side": Side.SIDE_RIGHT
		},
		{
			"name": "Kath",
			"text": "NÃO",
			"text_color": Color(1, 0, 0),
			"bg_color": Color(0, 0, 0, 0.8),
			"border_color": Color(0.0, 1.643, 0.339, 1.0),
			"animation": "Kath", 
			"side": Side.SIDE_LEFT
		},
	],

	[
		{
			"name": "Kath",
			"text": "Tava muito bom slk",
			"text_color": Color(1, 0, 0),
			"bg_color": Color(0, 0, 0, 0.8),
			"border_color": Color(0.0, 1.643, 0.339, 1.0),
			"animation": "Kath", 
			"side": Side.SIDE_LEFT
		},
		{
			"name": "Joao",
			"text": "Caralho acabo com o bolo",
			"text_color": Color(0.308, 0.493, 1.0, 1.0),
			"bg_color": Color(0, 0, 0, 0.8),
			"border_color": Color(0.576, 0.0, 1.546, 1.0),
			"animation": "Joao", 
			"side": Side.SIDE_RIGHT
		},
		{
			"name": "Nik",
			"text": "Comeu tudinho...",
			"text_color":Color(1.498, 0.0, 1.239, 1.0),
			"bg_color": Color(0, 0, 0, 0.8),
			"border_color": Color(0.0, 0.985, 1.266, 1.0),
			"animation": "Nik", 
			"side": Side.SIDE_RIGHT
		},
		{
			"name": "Eddw",
			"text": "Sobra nada mesmo",
			"text_color": Color(0.0, 0.655, 0.0, 1.0),
			"bg_color": Color(0, 0, 0, 0.8),
			"border_color": Color(1.643, 0.0, 0.0, 1.0),
			"animation": "Eddw", 
			"side": Side.SIDE_RIGHT
		},
		{
			"name": "Mamae",
			"text": "Meu Deus...",
			"text_color": Color(0.0, 0.632, 0.451, 1.0),
			"bg_color": Color(0, 0, 0, 0.8),
			"border_color": Color(1.643, 0.551, 0.0, 1.0),
			"animation": "Mamae", 
			"side": Side.SIDE_RIGHT
		},

	]
]


func _ready():

	sprite.hframes = 6
	sprite.frame = 0


# =========================================================
# INTERAGIR COM O BOLO
# =========================================================

func interagir():

	# Segurança
	if not pode_interagir():

		return null

	audio.play()
	# Pega o diálogo correspondente
	var dialogo_atual = dialogos[interacoes]
	await get_tree().create_timer(0.5).timeout
	audio.stop()


	# Avança o frame
	interacoes += 1

	sprite.frame = interacoes


	return dialogo_atual


# =========================================================
# VERIFICA SE AINDA PODE INTERAGIR
# =========================================================

func pode_interagir() -> bool:

	return interacoes < max_interacoes


# =========================================================
# QUANTIDADE DE INTERAÇÕES
# =========================================================

func quantidade_interacoes() -> int:

	return interacoes
