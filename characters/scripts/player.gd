extends CharacterBody2D
class_name Player

@onready var sprite: Sprite2D = $texture
@onready var camera: Camera2D = $Camera2D
@onready var animationCircle = $animationCircle
@onready var particles = $CPUParticles2D
@onready var loseStreak: Timer = $loseStreakTimer

var attackCounter = 0
var attackCooldown = 0.2

var _stateMachine

var SPEED = 100.0
const JUMP_VELOCITY = -400.0
var lastDirection = Vector2.LEFT

@export var friction = 0.2
@export var acc = 1
@export var bulletNode: PackedScene
@export var health = 100

@export_category("Dash Settings")
@export var dash_speed := 600.0
@export var dash_time := 0.2
@export var dash_cooldown := 1

@export_category("Knockback Settings")
@export var knockback_decay := 900.0

@export_category("Objects")
@export var _animationTree: AnimationTree = null

var originalColor := Color.WHITE

# ===============================
# VELOCIDADES SEPARADAS (IMPORTANTE)
# ===============================

var move_velocity: Vector2 = Vector2.ZERO
var external_velocity: Vector2 = Vector2.ZERO # knockback
var dash_velocity: Vector2 = Vector2.ZERO

# ===============================
# ESTADOS
# ===============================

var isRunning = false
var isDashing = false
var isDead = false
var canDash = true
var canAttack = true
var isAttacking = false
var isKokusen = false

# ===============================

func _ready():
	_stateMachine = _animationTree["parameters/playback"]
	originalColor = sprite.modulate


# ===============================
# PHYSICS PROCESS LIMPO
# ===============================

func _physics_process(delta: float) -> void:
	if Global.dialogueActive:
		_stateMachine.travel("idle")
		return

	# Knockback decai suavemente
	external_velocity = external_velocity.move_toward(Vector2.ZERO, knockback_decay * delta)

	if isDashing:
		velocity = dash_velocity
	else:
		move(delta)
		attack()
		dash()
		kokusen()
		animate()
		velocity = move_velocity + external_velocity

	move_and_slide()


# ===============================
# MOVIMENTO
# ===============================

func move(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if direction != Vector2.ZERO:
		lastDirection = direction
		
		_animationTree["parameters/kokusen/blend_position"] = direction 
		_animationTree["parameters/idle/blend_position"] = direction 
		_animationTree["parameters/walk/blend_position"] = direction 
		_animationTree["parameters/run/blend_position"] = direction 
		_animationTree["parameters/dash/blend_position"] = direction 
		_animationTree["parameters/attack/blend_position"] = direction
		
		
		move_velocity.x = lerp(move_velocity.x, direction.normalized().x * SPEED, acc)
		move_velocity.y = lerp(move_velocity.y, direction.normalized().y * SPEED, acc)
	else:
		move_velocity.x = lerp(move_velocity.x, 0.0, friction)
		move_velocity.y = lerp(move_velocity.y, 0.0, friction)

	if Input.is_action_pressed("run"):
		isRunning = true
		SPEED = 140.0
	else:
		isRunning = false
		SPEED = 100.0


# ===============================
# DASH PROFISSIONAL
# ===============================

func dash():
	if Input.is_action_just_pressed("dash"):
		if isDashing or !canDash:
			return

		isDashing = true
		canDash = false
		
		var dashDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		if dashDirection == Vector2.ZERO:
			dashDirection = lastDirection

		dash_velocity = dashDirection.normalized() * dash_speed
		
		# Zera forças durante dash
		external_velocity = Vector2.ZERO
		move_velocity = Vector2.ZERO

		particles.emitting = true
		
		await get_tree().create_timer(dash_time).timeout
		
		particles.emitting = false
		isDashing = false
		dash_velocity = Vector2.ZERO
		
		await get_tree().create_timer(dash_cooldown).timeout
		canDash = true


# ===============================
# ATAQUE
# ===============================

func attack():
	if Input.is_action_just_pressed("attack") and !isAttacking:
		if !canAttack:
			return
			
		isAttacking = true
		canAttack = false
		
		var attackDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		if attackDirection == Vector2.ZERO:
			attackDirection = lastDirection
		
		move_velocity = attackDirection.normalized() * 150
		
		if isRunning:
			isRunning = false
		
		await get_tree().create_timer(0.2).timeout
		isAttacking = false
		
		await get_tree().create_timer(attackCooldown).timeout
		canAttack = true


# ===============================
# KOKUSEN
# ===============================

func kokusen():
	if Input.is_action_just_pressed("kokusen"):
		if isKokusen:
			return
		
		isKokusen = true
		
		set_physics_process(false)
		await get_tree().create_timer(0.8).timeout
		
		camera.screenShake(4, 0.5)
		
		await get_tree().create_timer(0.7).timeout
		set_physics_process(true)
		isKokusen = false


# ===============================
# KNOCKBACK
# ===============================

func apply_knockback(from_position):
	var knockback_strength = 200.0
	
	if attackCounter == 3:
		knockback_strength = 400.0
	if isRunning:
		knockback_strength = 250.0
	
	var dir = (global_position - from_position).normalized()
	external_velocity = dir * knockback_strength


func takeDamage(fromPosition, knockback_strength):
	health -= 1
	hitFlash()

	# Cancela dash se tomar hit
	if isDashing:
		isDashing = false
		dash_velocity = Vector2.ZERO

	var dir = (global_position - fromPosition).normalized()
	external_velocity = dir * knockback_strength
	
	camera.screenShake(3, 0.3)


# ===============================
# ANIMAÇÃO
# ===============================

func animate():
	if health != null and health < 0:
		isDead = true
	
	if isDead:
		_stateMachine.travel("death")
		set_physics_process(false)
		animationCircle.play("circleDeathAnimation")
		return
	
	if isDashing:
		_stateMachine.travel("dash")
		return
	
	if isAttacking:
		_stateMachine.travel("attack")
		return
		
	if isKokusen:
		_stateMachine.travel("kokusen")
		return
	
	if velocity.length() > 1:
		if isRunning:
			_stateMachine.travel("run")
		else:
			_stateMachine.travel("walk")
		return
	
	_stateMachine.travel("idle")


# ===============================
# COMBATE
# ===============================

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.takeDamage()
		
		if attackCounter == 3:
			attackCooldown = 0.4
			attackCounter = 0
		else:
			attackCooldown = 0.2
		
		attackCounter += 1
		loseStreak.start()
		
		isRunning = false
		apply_knockback(body.global_position)
		camera.screenShake(3, 0.3)


func _on_lose_streak_timer_timeout() -> void:
	attackCounter = 0


# ===============================
# EFEITOS
# ===============================

func hitFlash():
	sprite.modulate = Color(5, 5, 5, 5)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = originalColor


# ===============================
# TIRO
# ===============================

func shoot():
	var bullet = bulletNode.instantiate()
	bullet.position = global_position
	bullet.direction = (get_global_mouse_position() - global_position).normalized()
	get_tree().current_scene.call_deferred("add_child", bullet)
