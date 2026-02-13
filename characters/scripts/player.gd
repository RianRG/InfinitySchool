extends CharacterBody2D
class_name Player

@onready var sprite: Sprite2D = $texture
@onready var camera: Camera2D = $Camera2D
@onready var animationCircle = $animationCircle
@onready var particles = $CPUParticles2D
@onready var loseStreak: Timer = $loseStreakTimer

var attackCounter=0
var attackCooldown=0.2

var _stateMachine

var SPEED = 100.0
const JUMP_VELOCITY = -400.0
var lastDirection = Vector2.LEFT
@export var friction = 0.2
@export var acc = 0.2
@export var bulletNode: PackedScene
@export var health = 100
@export_category("Objects")
@export var _animationTree: AnimationTree = null

var originalColor:= Color.WHITE

var knockback_velocity: Vector2 = Vector2.ZERO
var knockback_decay := 700.0 # quanto maior, mais rápido para
# n tira o texto n babaca
func _ready():
	_stateMachine = _animationTree["parameters/playback"]
	originalColor = sprite.modulate

var isRunning = false
var isDashing = false
var isDead = false
var canDash=true
var canAttack=true
var isAttacking=false
var isKokusen = false

func _physics_process(delta: float) -> void:
	if Global.dialogueActive:
		_stateMachine.travel("idle")
		return
	
	if knockback_velocity.length() > 1:
		velocity += knockback_velocity
		knockback_velocity = knockback_velocity.lerp(Vector2.ZERO, 0.2)
	
	if isDashing || isAttacking || isKokusen:
		move_and_slide()
	else:
		move(delta)
		attack()
		dash()
		kokusen()
		animate()
		move_and_slide()

func shoot():
	var bullet = bulletNode.instantiate()
	
	bullet.position = global_position
	bullet.direction = (get_global_mouse_position() - global_position).normalized()
	get_tree().current_scene.call_deferred("add_child", bullet)

#func _input(event):
	#if event.is_action("shoot"):
		#shoot()
	#if event.is_action("dash"):
		#dash()
	#if event.is_action("attack") && !isAttacking:
		#attack()
		#
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
		
		
		
		
		velocity.x = lerp(velocity.x, direction.normalized().x*SPEED, acc)
		velocity.y = lerp(velocity.y, direction.normalized().y*SPEED, acc)
	else:
		velocity.x = lerp(velocity.x, direction.normalized().x*SPEED, friction)
		velocity.y = lerp(velocity.y, direction.normalized().y*SPEED, friction)


	if Input.is_action_pressed("run"):
		isRunning = true
	if Input.is_action_just_released("run"):
		isRunning = false
	if isRunning:
		SPEED=140.0
	else:
		SPEED=100.0
		
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_decay * delta)
	velocity += knockback_velocity

func animate():
	
	if health<0:
		isDead=true
	
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
	
	if velocity.length()>1:
		if isRunning && !isDashing:
			_stateMachine.travel("run")
		elif !isRunning && !isDashing:
			_stateMachine.travel("walk")	
		return
	_stateMachine.travel("idle")
	
	
func kokusen():
	if Input.is_action_just_pressed("kokusen"):
		if isKokusen: return
		
		isKokusen=true
		
		set_physics_process(false)
		await get_tree().create_timer(0.8).timeout
		camera.screenShake(4, 0.5)
		
		await get_tree().create_timer(0.7).timeout
		set_physics_process(true)
		isKokusen=false
		
	
func dash():
	if Input.is_action_just_pressed("dash"):
		if isDashing || !canDash:
			return
		isDashing=true
		canDash=false
		var dashDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		
		
		if dashDirection==Vector2.ZERO:
			dashDirection=lastDirection
		velocity = dashDirection.normalized()*350
		
		particles.emitting=true
		await get_tree().create_timer(0.17).timeout
		particles.emitting=false
		isDashing=false
		
		await get_tree().create_timer(0.45).timeout
		canDash=true
	
func attack():
	if Input.is_action_just_pressed("attack") && !isAttacking:
		if !canAttack:
			return
			
		isAttacking=true
		canAttack=false
		
		var attackDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		if attackDirection==Vector2.ZERO:
			attackDirection=lastDirection
		velocity = attackDirection.normalized()*150
	
		
	
		if isRunning:
			isRunning=false
		await get_tree().create_timer(0.2).timeout
		isAttacking=false
		await get_tree().create_timer(attackCooldown).timeout
		canAttack=true
	
func apply_knockback(from_position):
	var knockback_strenght = 60.0
	if attackCounter == 3: knockback_strenght = 100.0
	if isRunning:	
		knockback_strenght = 250.0
	
	var dir = (global_position - from_position).normalized()
	knockback_velocity = dir * knockback_strenght * 0.9

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.takeDamage()
		if attackCounter==3:
			attackCooldown=0.4
			attackCounter=0
		else:
			attackCooldown=0.2
		attackCounter+=1
		loseStreak.start()
		
		isRunning = false
		apply_knockback(body.global_position)
		camera.screenShake(2, 0.3)
		await get_tree().create_timer(0.5).timeout
		
	pass # Replace with function body.


func hitFlash():
	sprite.modulate = Color(5, 5, 5, 5)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = originalColor


func takeDamage(fromPosition):
	health-=1
	hitFlash()
	
	var knockback_strength = 80.0
	var dir = (global_position - fromPosition).normalized()
	knockback_velocity = dir * knockback_strength
	camera.screenShake(2, 0.3)
	#Engine.time_scale = 0.3  # câmera lenta
	#await get_tree().create_timer(0.2).timeout  # 0.2s em slow-mo
	#Engine.time_scale = 1.0  # volta ao normal


func _on_lose_streak_timer_timeout() -> void:
	attackCounter=0
	pass # Replace with function body.
