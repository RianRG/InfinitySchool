extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var player = get_parent().find_child("player")
var direction: Vector2
var DEF=0

@onready var animationTree: AnimationTree = $AnimationTree

var stateMachine

var originalColor := Color.WHITE
var knockback_velocity: Vector2 = Vector2.ZERO
var knockback_decay := 700.0 # quanto maior, mais rápido ele "freia"
var onState = false
var health=100:
	set(value):
		health=value
		if value==0:
			find_child("FiniteStateMachine").change_state("death")
		elif value<=50 && DEF==0:
			DEF=5
			#find_child("FiniteStateMachine").change_state("armorBuff")
			# possível 2 fase

func _ready():
	stateMachine = animationTree["parameters/playback"]
	
	set_physics_process(false)
	originalColor = sprite.modulate

func _process(delta):
	if player == null: return
	direction = player.position-position
	
	animationTree["parameters/walk/blend_position"] = direction
	animationTree["parameters/attack/blend_position"] = direction
	
	#if direction.x<0 && health>0:
		#sprite.flip_h=true
	#elif direction.x>=0 && health>0:
		#sprite.flip_h=false

func _physics_process(delta):
	var move_velocity = direction.normalized()*160
	#var move_velocity = direction.normalized()*0
	
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_decay * delta)
	velocity = move_velocity + knockback_velocity
	move_and_slide()

func hitFlash():
	sprite.modulate = Color(5, 5, 5, 5)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = originalColor
const purpleAttackVfx = preload("res://assets/vfx/purpleAttackVfx.tscn")
func takeDamage():
	# Reduz a vida
	health -= 10 - DEF
	var attackScene = purpleAttackVfx.instantiate()
	attackScene.position = position
	get_parent().add_child(attackScene)
	attackScene.scale = Vector2(1.5, 1.5)
	
	
	
	# --- Knockback ---
	var direction_from_player = (global_position - player.position).normalized()
	attackScene.rotation = direction_from_player.angle() + 1.7
	print(-direction_from_player.angle())
	var knockback_strength = 200.0
	knockback_velocity = direction_from_player * knockback_strength
	
	hitFlash()
	
