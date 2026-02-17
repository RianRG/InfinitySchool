extends CharacterBody2D
class_name Player

# ===============================
# NODES
# ===============================
@onready var sprite: Sprite2D = $texture
@onready var camera = get_parent().get_node("Camera2D")
@onready var animationCircle = $animationCircle
@onready var particles = $CPUParticles2D
@onready var loseStreak: Timer = $loseStreakTimer

# TTimers gerenciados
var dash_timer: Timer
var dash_cooldown_timer: Timer
var attack_cooldown_timer: Timer
var kokusen_timer: Timer
var spin_timer: Timer
var spin_end_timer: Timer
var heal_timer: Timer

# ===============================
# EXPORTS
# ===============================
@export var friction = 0.2
@export var acc = 0.35
@export var bulletNode: PackedScene
@export var health = 100

@export_category("Movement")
@export var SPEED = 150.0
@export var JUMP_VELOCITY = -400.0

@export_category("Dash Settings")
@export var dash_speed := 600.0
@export var dash_time := 0.2
@export var dash_cooldown := 1.0

@export_category("Attack Settings")
@export var base_attack_cooldown := 0.4
@export var combo_attack_cooldown := 0.8
@export var attack_dash_speed := 150.0
@export var attack_duration := 0.5
@export var combo_window := 1.0

@export_category("Knockback Settings")
@export var knockback_decay := 900.0

@export_category("Kokusen Settings")
@export var kokusen_freeze_duration := 1
@export var kokusen_end_duration := 0.3

@export_category("Spin Settings")
@export var spin_startup_duration := 0.6
@export var spin_duration := 6.0
@export var spin_end_duration := 0.8

@export_category("Objects")
@export var _animationTree: AnimationTree = null

# ===============================
# STATE MACHINE
# ===============================
enum PlayerState {
	IDLE,
	MOVING,
	DASHING,
	ATTACKING,
	KOKUSEN,
	SPINNING_STARTUP,
	SPINNING,
	SPIN_END,
	HEALING,
	DEAD
}

var current_state: PlayerState = PlayerState.IDLE
var _stateMachine

# ===============================
# MOVEMENT & COMBAT
# ===============================
var move_velocity: Vector2 = Vector2.ZERO
var external_velocity: Vector2 = Vector2.ZERO
var dash_velocity: Vector2 = Vector2.ZERO
var lastDirection = Vector2.LEFT

var attackCounter = 0
var isRunning = false
var canDash = true
var canAttack = true
var spin_started = false
var canHeal=true

var originalColor := Color.WHITE

# ===============================
# READY
# ===============================
func _ready():
	_stateMachine = _animationTree["parameters/playback"]
	originalColor = sprite.modulate
	_animationTree.active = true
	
	_setup_timers()

func _setup_timers():
	# Dash timer
	dash_timer = Timer.new()
	dash_timer.one_shot = true
	dash_timer.timeout.connect(_on_dash_timer_timeout)
	add_child(dash_timer)
	
	# Dash cooldown
	dash_cooldown_timer = Timer.new()
	dash_cooldown_timer.one_shot = true
	dash_cooldown_timer.timeout.connect(_on_dash_cooldown_timeout)
	add_child(dash_cooldown_timer)
	
	# Attack cooldown
	attack_cooldown_timer = Timer.new()
	attack_cooldown_timer.one_shot = true
	attack_cooldown_timer.timeout.connect(_on_attack_cooldown_timeout)
	add_child(attack_cooldown_timer)
	
	# Kokusen timer
	kokusen_timer = Timer.new()
	kokusen_timer.one_shot = true
	kokusen_timer.timeout.connect(_on_kokusen_timer_timeout)
	add_child(kokusen_timer)
	
	# Spin timer
	spin_timer = Timer.new()
	spin_timer.one_shot = true
	spin_timer.timeout.connect(_on_spin_timer_timeout)
	add_child(spin_timer)
	
	# Spin end timer
	spin_end_timer = Timer.new()
	spin_end_timer.one_shot = true
	spin_end_timer.timeout.connect(_on_spin_end_timer_timeout)
	add_child(spin_end_timer)
	
	# Heal timer
	heal_timer = Timer.new()
	heal_timer.one_shot=true
	heal_timer.timeout.connect(_on_heal_timer_timeout)
	add_child(heal_timer)

# ===============================
# PHYSICS PROCESS
# ===============================
func _physics_process(delta: float) -> void:
	if Global.dialogueActive:
		_stateMachine.travel("idle")
		return
	
	# Decay knockback
	external_velocity = external_velocity.move_toward(Vector2.ZERO, knockback_decay * delta)
	
	# Process current state
	_process_state(delta)
	
	# Handle input (unless locked)
	if _can_handle_input():
		_handle_input()
	
	# Update velocity and move
	_update_velocity()
	move_and_slide()
	
	# Update animation
	_update_animation()

# ===============================
# STATE MACHINE LOGIC
# ===============================
func _process_state(delta: float):
	match current_state:
		PlayerState.IDLE, PlayerState.MOVING, PlayerState.HEALING:
			_process_movement(delta)
		
		PlayerState.DASHING:
			velocity = dash_velocity
		
		PlayerState.ATTACKING:
			# Movement is set when entering attack state
			pass
		
		PlayerState.KOKUSEN:
			# Frozen during kokusen
			velocity = Vector2.ZERO
		
		PlayerState.SPINNING_STARTUP:
			velocity = Vector2.ZERO
		
		PlayerState.SPINNING:
			_process_movement(delta)
		
		PlayerState.SPIN_END:
			# PARADO durante recovery
			velocity = Vector2.ZERO
		
		PlayerState.DEAD:
			velocity = Vector2.ZERO
func _can_handle_input() -> bool:
	return current_state in [PlayerState.IDLE, PlayerState.MOVING ]

func _handle_input():
	if Input.is_action_just_pressed("dash"):
		_try_dash()
	
	if Input.is_action_just_pressed("attack"):
		_try_attack()
	
	if Input.is_action_just_pressed("kokusen"):
		_try_kokusen()
	
	if Input.is_action_just_pressed("spin"):
		_try_spin()
		
	if Input.is_action_just_pressed("heal"):
		_try_heal()

# ===============================
# MOVEMENT
# ===============================
func _process_movement(delta: float):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction != Vector2.ZERO:
		lastDirection = direction
		_update_animation_blend_positions(direction)
		
		move_velocity.x = lerp(move_velocity.x, direction.normalized().x * SPEED, acc)
		move_velocity.y = lerp(move_velocity.y, direction.normalized().y * SPEED, acc)
		
		if current_state == PlayerState.IDLE:
			_change_state(PlayerState.MOVING)
	else:
		move_velocity = Vector2.ZERO
		#move_velocity.x = lerp(move_velocity.x, 0.0, friction)
		#move_velocity.y = lerp(move_velocity.y, 0.0, friction)
		
		if current_state == PlayerState.MOVING and move_velocity.length() < 1.0:
			_change_state(PlayerState.IDLE)

func _update_animation_blend_positions(direction: Vector2):
	_animationTree["parameters/kokusen/blend_position"] = direction
	_animationTree["parameters/idle/blend_position"] = direction
	_animationTree["parameters/walk/blend_position"] = direction
	_animationTree["parameters/run/blend_position"] = direction
	_animationTree["parameters/dash/blend_position"] = direction
	_animationTree["parameters/attack/blend_position"] = direction
	_animationTree["parameters/combo/blend_position"] = direction
	

# ===============================
# DASH
# ===============================
func _try_dash():
	if not canDash or current_state in [PlayerState.SPINNING || PlayerState.HEALING]:
		return
	
	_change_state(PlayerState.DASHING)
	canDash = false
	
	var dashDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if dashDirection == Vector2.ZERO:
		dashDirection = lastDirection
	
	dash_velocity = dashDirection.normalized() * dash_speed
	external_velocity = Vector2.ZERO
	move_velocity = Vector2.ZERO
	
	particles.emitting = true
	dash_timer.start(dash_time)
	dash_cooldown_timer.start(dash_time + dash_cooldown)

func _on_dash_timer_timeout():
	particles.emitting = false
	dash_velocity = Vector2.ZERO
	_change_state(PlayerState.IDLE)

func _on_dash_cooldown_timeout():
	canDash = true

# ===============================
# ATTACK
# ===============================

func _try_attack():
	if not canAttack or current_state not in [PlayerState.IDLE, PlayerState.MOVING]:
		return
	
	_change_state(PlayerState.ATTACKING)
	canAttack = false
	
	var attackDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if attackDirection == Vector2.ZERO:
		attackDirection = lastDirection
	
	
	if attackCounter == 2:  # 2 porque ainda não incrementou
		_stateMachine.travel("combo")
	else:
		_stateMachine.travel("attack")
	
	move_velocity = attackDirection.normalized() * attack_dash_speed
	
	if isRunning:
		isRunning = false
	attack_cooldown_timer.start(base_attack_cooldown)
func _on_attack_cooldown_timeout():
	canAttack = true


# =======
# HEAL
# =======
const healVfxScene: PackedScene = preload("res://assets/vfx/healVfx.tscn")
func _try_heal():
	if !canHeal || current_state in [PlayerState.DASHING, PlayerState.ATTACKING]:
		return
		
	_change_state(PlayerState.HEALING)
	heal_timer.start(0.6)
	freezeFrame(0.5, 0.5)
	canHeal=false
	
	
	var healVfx = healVfxScene.instantiate() 
	add_child(healVfx)
	healVfx.position = Vector2(0,-20)
		
	
func _on_heal_timer_timeout():
	canHeal=true	
	_change_state(PlayerState.IDLE)

# ===============================
# KOKUSEN
# ===============================
func _try_kokusen():
	if current_state == PlayerState.KOKUSEN:
		return
	
	_change_state(PlayerState.KOKUSEN)
	kokusen_timer.start(kokusen_freeze_duration)

func _on_kokusen_timer_timeout():
	camera.screenShake(4, 0.5)
	
	
	# Timer for end of kokusen
	var end_timer = get_tree().create_timer(kokusen_end_duration)
	end_timer.timeout.connect(_on_kokusen_end)

func _on_kokusen_end():
	_change_state(PlayerState.IDLE)

# ===============================
# SPIN ATTACK
# ===============================
func _try_spin():
	if current_state == PlayerState.SPINNING or current_state == PlayerState.SPINNING_STARTUP:
		return
	
	# Fase 1: STARTUP (parado)
	_change_state(PlayerState.SPINNING_STARTUP)
	spin_started = false
	SPEED+=50.0
	spin_timer.start(spin_startup_duration)  # 0.6s parado

func _on_spin_timer_timeout():
	# Fase 2: SPINNING (se move normalmente)
	_change_state(PlayerState.SPINNING)
	spin_end_timer.start(spin_duration)  # 6s girando

func _on_spin_end_timer_timeout():
	# Fase 3: RECOVERY (parado de novo)
	_change_state(PlayerState.SPIN_END)
	_animationTree.set("parameters/conditions/finishedSpin", true)
	SPEED-=50.0
	
	

	
	# Timer final de recovery
	var final_timer = get_tree().create_timer(spin_end_duration)  # 0.8s parado
	final_timer.timeout.connect(_on_spin_complete)

func _on_spin_complete():
	_animationTree.set("parameters/conditions/finishedSpin", false)
	_change_state(PlayerState.IDLE)
# ===============================
# STATE TRANSITIONS
# ===============================
func _change_state(new_state: PlayerState):
	var old_state = current_state
	current_state = new_state
	if old_state == PlayerState.DASHING and new_state != PlayerState.DASHING:
		particles.emitting = false
	# Debug
	# print("State changed: %s -> %s" % [PlayerState.keys()[old_state], PlayerState.keys()[new_state]])

# ===============================
# VELOCITY UPDATE
# ===============================
func _update_velocity():
	match current_state:
		PlayerState.DASHING:
			velocity = dash_velocity
		PlayerState.KOKUSEN, PlayerState.SPINNING_STARTUP, PlayerState.SPIN_END, PlayerState.DEAD:
			velocity = Vector2.ZERO
		PlayerState.SPINNING:  # ← ADICIONE CASO SEPARADO
			velocity = move_velocity + external_velocity  # SE MOVE!
		_:
			velocity = move_velocity + external_velocity
# ===============================
# ANIMATION
# ===============================
func _update_animation():
	if health <= 0 and current_state != PlayerState.DEAD:
		_change_state(PlayerState.DEAD)
	
	match current_state:
		PlayerState.DEAD:
			_stateMachine.travel("death")
			animationCircle.play("circleDeathAnimation")
		
		PlayerState.DASHING:
			_stateMachine.travel("dash")
		
		PlayerState.SPINNING_STARTUP:  # ← ADICIONE
			if not spin_started:
				_stateMachine.travel("spinAttackStart")
				spin_started = true
		
		PlayerState.SPINNING:  # ← MODIFIQUE
			# Mantém a animação de spin
			pass
		
		PlayerState.SPIN_END:  # ← ADICIONE
			# Animação de recovery/finalização
			pass
		
		PlayerState.ATTACKING:
			pass
		PlayerState.KOKUSEN:
			_stateMachine.travel("kokusen")
		
		PlayerState.MOVING:
			_stateMachine.travel("run")
		
		PlayerState.IDLE:
			_stateMachine.travel("idle")
# ===============================
# KNOCKBACK & DAMAGE
# ===============================
func apply_knockback(from_position: Vector2, knockback_strength):
	
	var dir = (global_position - from_position).normalized()
	external_velocity = Vector2.ZERO
	external_velocity = dir * knockback_strength

func takeDamage(fromPosition: Vector2, knockback_strength: float):
	health -= 1
	hitFlash()
	
	# Cancel dash on hit
	if current_state == PlayerState.DASHING:
		dash_timer.stop()
		dash_velocity = Vector2.ZERO
		_change_state(PlayerState.IDLE)
	
	var dir = (global_position - fromPosition).normalized()
	external_velocity = dir * knockback_strength
	
	camera.screenShake(3, 0.3)

# ===============================
# COMBAT
# ===============================
func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.takeDamage()
		attackCounter += 1
		if current_state == PlayerState.KOKUSEN:
			freezeFrame(0.3, 0.5)
		
		# Reseta o timer a cada acerto
		loseStreak.start(combo_window)
		var current_cooldown: float
		# Lógica do 3º hit
		if attackCounter == 3:
			current_cooldown = combo_attack_cooldown # Cooldown maior
			apply_knockback(body.global_position, 500)  # Knockback maior
			camera.screenShake(5, 0.5)  # Shake mais forte
			attackCounter = 0  # Reseta combo
			print("COMBO HIT 3!!")
		else:
			current_cooldown = base_attack_cooldown  # Cooldown normal
			apply_knockback(body.global_position, 350)  # Knockback normal
			camera.screenShake(3, 0.3)
			print("Hit %d" % attackCounter)
			
			
		attack_cooldown_timer.stop()
		attack_cooldown_timer.start(current_cooldown)
		isRunning = false
func _on_lose_streak_timer_timeout() -> void:
	if attackCounter > 0:  # ← ADICIONE ESTA LINHA
		print("Combo perdido! (tempo expirou)")
	attackCounter = 0

# ===============================
# EFFECTS
# ===============================
func hitFlash():
	sprite.modulate = Color(5, 5, 5, 5)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = originalColor


# ===============================
# SHOOTING
# ===============================
func shoot():
	var bullet = bulletNode.instantiate()
	bullet.position = global_position
	bullet.direction = (get_global_mouse_position() - global_position).normalized()
	get_tree().current_scene.call_deferred("add_child", bullet)

# Freeze frame
func freezeFrame(timeScale: float, time: float):
	Engine.time_scale=timeScale # slow motion
	#Engine.time_scale=0 freeze frame
	
	await get_tree().create_timer(time, true, false, true).timeout
	
	Engine.time_scale=1


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if "attack" in anim_name || "combo" in anim_name:
		if current_state == PlayerState.ATTACKING:
			_change_state(PlayerState.IDLE)
		
	pass # Replace with function body.
