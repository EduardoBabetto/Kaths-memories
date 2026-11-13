extends CharacterBody2D

# Variáveis que você pode ajustar no Editor
@export var speed = 300
@export var acceleration = 1500
@export var friction = 1200

# Função que roda a cada frame (para física)
func _physics_process(delta):
	# 1. Pegar entrada do teclado
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()  # Normaliza para movimento diagonal não ser mais rápido
	
	# 2. Aplicar movimento
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	# 3. Mover o personagem
	move_and_slide()

# Função para debug (opcional)
func _process(delta):
	# Mostra posição no console (útil para testar)
	if Input.is_action_just_pressed("ui_accept"):
		print("Posição do Player: ", position)
