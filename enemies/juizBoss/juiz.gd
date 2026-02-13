extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var player = get_parent().find_child("player")
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var animationTree: AnimationTree = $AnimationTree

var direction: Vector2
var dash_direction: Vector2 = Vector2.ZERO

var DEF = 0
var attackCounter = 0
var onAttackCooldown := false
var stateMachine
var speed = 160
var originalColor := Color.WHITE

var knockback_velocity: Vector2 = Vector2.ZERO
var knockback_decay := 700.0
var onState = false

var health = 100:
	set(value):
		health = value
		if value <= 0:
			find_child("FiniteStateMachine").change_state("death")
		elif value <= 50 and DEF == 0:
			DEF = 5


func _ready():
	animationTree.active = true
	stateMachine = animationTree["parameters/playback"]
	originalColor = sprite.modulate


func _process(delta):
	if player == null:
		return
	
	# Atualiza direção normalmente (usado para follow)
	direction = player.position - position
	
	animationTree["parameters/walk/blend_position"] = direction
	animationTree["parameters/attack/blend_position"] = direction


func _physics_process(delta):
	var move_velocity = Vector2.ZERO
	
	# Só segue o player se NÃO estiver atacando
	if !onState:
		move_velocity = direction.normalized() * speed
	
	# Decaimento do dash / knockback
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_decay * delta)
	
	velocity = move_velocity + knockback_velocity
	move_and_slide()


# ======================
# ATAQUES
# ======================

func dashAttack():
	onState = true
	
	# Calcula direção UMA VEZ
	dash_direction = (player.position - global_position).normalized()
	knockback_velocity = dash_direction * 400

func spinAttack():
	# Recalcula direção apenas no início do segundo dash
	dash_direction = (player.position - global_position).normalized()
	knockback_velocity = dash_direction * 800


func endSpinAttack():
	onState = false
	speed = 60
	onAttackCooldown = true
	
	startAttackCooldown()
	find_child("FiniteStateMachine").change_state("follow")


func startAttackCooldown():
	await get_tree().create_timer(0.5).timeout
	speed = 160
	onAttackCooldown = false


# ======================
# DANO
# ======================

const purpleAttackVfx = preload("res://assets/vfx/purpleAttackVfx.tscn")

func takeDamage():
	health -= 10 - DEF
	
	var attackScene = purpleAttackVfx.instantiate()
	attackScene.position = position
	get_parent().add_child(attackScene)
	attackScene.scale = Vector2(1.5, 1.5)
	
	var direction_from_player = (global_position - player.position).normalized()
	attackScene.rotation = direction_from_player.angle() + 1.7
	
	var knockback_strength = 100.0
	knockback_velocity = direction_from_player * knockback_strength
	
	hitFlash()


func hitFlash():
	sprite.modulate = Color(5, 5, 5, 5)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = originalColor
