extends CharacterBody2D

enum PlayerState{
	idle,
	walk,
	jump,
	fall
}

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

@export var MAX_SPEED = 100.0
@export var ACCELERATION = 800
@export var DECELERATION = 1000
@export var AIR_ACCELERATION = 400

const JUMP_VELOCITY = -350.0
var can_move = true

var JUMP_COUNT = 0
@export var JUMP_MAX_COUNT = 2

var direction = 0
var status : PlayerState

func move(delta):
	update_direction()

	var accel = ACCELERATION if is_on_floor() else AIR_ACCELERATION
	
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED, accel * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)

func _ready() -> void:
	go_to_idle_state()

func _physics_process(delta: float) -> void:
	if not can_move:
		velocity = Vector2.ZERO
		move_and_slide()
		return
		
	# Gravidade só no Y
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	else:
		JUMP_COUNT = 0

	match status:
		PlayerState.idle:
			idle_state(delta)
		PlayerState.walk:
			walk_state(delta)
		PlayerState.jump:
			jump_state(delta)
		PlayerState.fall:
			fall_state(delta)

	move_and_slide()

# ================== STATES ==================

func go_to_idle_state():
	status = PlayerState.idle
	anim.play("idle")

func go_to_walk_state():
	status = PlayerState.walk
	anim.play("walking")

func go_to_jump_state():
	status = PlayerState.jump
	anim.play("jump")
	velocity.y = JUMP_VELOCITY
	JUMP_COUNT += 1

func go_to_fall_state():
	status = PlayerState.fall
	anim.play("falling")

# ================== LOGIC ==================

func idle_state(delta):
	move(delta)

	if !is_on_floor():
		go_to_fall_state()
		return

	if Input.is_action_just_pressed("ui_accept"):
		go_to_jump_state()
		return

	if abs(velocity.x) > 5:
		go_to_walk_state()
		return

func walk_state(delta):
	move(delta)

	if !is_on_floor():
		go_to_fall_state()
		return

	if Input.is_action_just_pressed("ui_accept"):
		go_to_jump_state()
		return

	if abs(velocity.x) < 5:
		go_to_idle_state()
		return

func jump_state(delta):
	move(delta)

	if Input.is_action_just_pressed("ui_accept") and can_jump():
		go_to_jump_state()

	if velocity.y > 0:
		go_to_fall_state()
		return

func fall_state(delta):
	move(delta)

	if Input.is_action_just_pressed("ui_accept") and can_jump():
		go_to_jump_state()
		return

	if is_on_floor():
		if abs(velocity.x) < 5:
			go_to_idle_state()
		else:
			go_to_walk_state()

# ================== HELPERS ==================

func update_direction():
	direction = Input.get_axis("ui_left", "ui_right")

	if direction < 0:
		anim.flip_h = true
	elif direction > 0:
		anim.flip_h = false

func can_jump() -> bool:
	return JUMP_COUNT < JUMP_MAX_COUNT


func _on_level_end_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
