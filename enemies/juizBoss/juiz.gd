extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var player = get_parent().find_child("player")
@onready var animationTree: AnimationTree = $AnimationTree

var direction: Vector2 = Vector2.ZERO
var target_direction: Vector2 = Vector2.ZERO

var DEF = 0
var onAttackCooldown := false
var stateMachine
var speed := 160
var originalColor := Color.WHITE
var isDead:=false

var knockback_velocity: Vector2 = Vector2.ZERO
var knockback_decay := 700.0
var cannotTakeKnockback = false
var canMove:=false

# Controle de atualização de direção
var direction_update_timer := 0.0
var direction_update_interval := 0.25
var direction_smoothness := 4.0

# ✅ Mudança: agora empurra o PLAYER ao invés do boss
var player_push_strength := 900.0

# Zona mínima real
var min_follow_distance := 60.0

var health = 1000:
	set(value):
		health = value
		if value <= 0:
			if !isDead: player.freezeFrame(0.4, 3)
			isDead=true
			find_child("FiniteStateMachine").change_state("death")


func _ready():
	animationTree.active = true
	stateMachine = animationTree["parameters/playback"]
	originalColor = sprite.modulate
	


func _process(delta):
	#set_physics_process(false)
	if player == null || !canMove:
		return
	
	var distance_to_player = global_position.distance_to(player.global_position)
	
	# Atualiza direção apenas em intervalos
	if !cannotTakeKnockback:
		direction_update_timer += delta
		if direction_update_timer >= direction_update_interval:
			direction_update_timer = 0.0
			
			# Só recalcula se estiver fora da zona mínima
			if distance_to_player > min_follow_distance:
				target_direction = (player.global_position - global_position).normalized()
		
		# Suavização profissional
		direction = direction.move_toward(target_direction, direction_smoothness * delta)
	
	animationTree["parameters/walk/blend_position"] = direction
	animationTree["parameters/attack/blend_position"] = direction


func _physics_process(delta):
	if player == null || !canMove:
		velocity=Vector2.ZERO
		knockback_velocity=Vector2.ZERO
		return
	
	var distance_to_player = global_position.distance_to(player.global_position)
	
	# Decaimento de knockback
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_decay * delta)
	
	
	
	# ✅ Empurra o PLAYER ao invés do boss
	if distance_to_player < min_follow_distance:
		var push_dir = (player.global_position - global_position).normalized()
		var overlap_ratio = 1.0 - (distance_to_player / min_follow_distance)
		var push_force = player_push_strength * overlap_ratio
	
	# ✅ Aplica knockback no player
		if (player.external_velocity.length() < push_force &&
		player.current_state != player.PlayerState.DASHING):
			player.external_velocity = push_dir * push_force
			
	
	var move_velocity = Vector2.ZERO

	if cannotTakeKnockback:
		# Durante dash/ataque, mantém a velocidade do ataque
		move_velocity = knockback_velocity
	elif knockback_velocity.length() > 2.0:
		move_velocity = Vector2.ZERO
	else:
		# Movimento normal + direção suavizada
		move_velocity = direction * speed

	# ✅ Agora não precisa mais de separation_velocity, só knockback de dano
	var total_velocity = move_velocity
	
	if not cannotTakeKnockback:
		total_velocity += knockback_velocity

	velocity = total_velocity
	
	move_and_slide()


# ======================
# DANO
# ======================

const purpleAttackVfx = preload("res://assets/vfx/purpleAttackVfx.tscn")

func takeDamage():
	health -= 10 - DEF

	# Spawn do VFX
	var attackScene = purpleAttackVfx.instantiate()
	attackScene.position = global_position
	get_parent().add_child(attackScene)
	attackScene.scale = Vector2(1, 1)
	
	var direction_from_player = (global_position - player.global_position).normalized()
	attackScene.rotation = direction_from_player.angle() + 1.7
	
	# Só aplica knockback se o boss NÃO estiver atacando/dash
	if not cannotTakeKnockback:
		var knockback_strength = 400.0
		knockback_velocity = direction_from_player * knockback_strength
	else:
		# Feedback visual para mostrar que ele levou hit no dash
		sprite.modulate = Color(1, 0.5, 0.5)
		await get_tree().create_timer(0.05).timeout
		sprite.modulate = originalColor
	
	hitFlash()


func hitFlash():
	sprite.modulate = Color(5, 5, 5, 5)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = originalColor
