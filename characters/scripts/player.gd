extends CharacterBody2D
class_name Player

@onready var sprite: Sprite2D = $texture
@onready var camera: Camera2D = $Camera2D
@onready var animationCircle = $animationCircle
@onready var particles = $CPUParticles2D


var _stateMachine

var SPEED = 80.0
const JUMP_VELOCITY = -400.0
var lastDirection = Vector2.LEFT
@export var friction = 0.2
@export var acc = 0.2
@export var bulletNode: PackedScene
@export var health = 5
@export_category("Objects")
@export var _animationTree: AnimationTree = null

var knockback_velocity: Vector2 = Vector2.ZERO
var knockback_decay := 700.0 # quanto maior, mais rápido para
# akjdkajdakjdkajdakjdkjakj
func _ready():
	_stateMachine = _animationTree["parameters/playback"]
	
	var shader_code = """
		shader_type canvas_item;
		uniform bool hit_flash = false;

		void fragment() {
			vec4 tex_color = texture(TEXTURE, UV);
			if (hit_flash && tex_color.a > 0.0) {
				COLOR = vec4(1.0, 1.0, 1.0, tex_color.a); // branco puro
			} else {
				COLOR = tex_color;
			}
		}
	"""
	var shader = Shader.new()
	shader.code = shader_code
	var shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	sprite.material = shader_material


var isRunning = false
var isDashing = false
var isDead = false
var canDash=true
var canAttack=true
var isAttacking=false

func _physics_process(delta: float) -> void:
	if isDashing || isAttacking:
		move_and_slide()
	else:
		move(delta)
		attack()
		dash()
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
		SPEED=200.0
	else:
		SPEED=80.0
		
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_decay * delta)
	velocity += knockback_velocity

func animate():
	
	if health==0:
		isDead=true
	
	if isDead:
		_stateMachine.travel("death")
		set_physics_process(false)
		animationCircle.play("deathAnimation")
		return
	
	if isDashing:
		_stateMachine.travel("dash")
		return
	
	if isAttacking:
		_stateMachine.travel("attack")
		return
	
	if velocity.length()>1:
		if isRunning && !isDashing:
			_stateMachine.travel("run")
		elif !isRunning && !isDashing:
			_stateMachine.travel("walk")	
		return
	_stateMachine.travel("idle")
	
func dash():
	if Input.is_action_just_pressed("dash"):
		if isDashing || !canDash:
			return
		isDashing=true
		canDash=false
		var dashDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		
		
		if dashDirection==Vector2.ZERO:
			dashDirection=lastDirection
		velocity = dashDirection.normalized()*300
		
		particles.emitting=true
		await get_tree().create_timer(0.3).timeout
		particles.emitting=false
		isDashing=false
		
		await get_tree().create_timer(0.6).timeout
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
		velocity = attackDirection.normalized()*200
	
		if isRunning:
			isRunning=false
		await get_tree().create_timer(0.2).timeout
		isAttacking=false
		await get_tree().create_timer(0.4).timeout
		canAttack=true
	


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.takeDamage()
		camera.screenShake(4, 0.3)
	pass # Replace with function body.


func takeDamage(fromPosition):
	health-=1
	var knockback_strength = 80.0
	var dir = (global_position - fromPosition).normalized()
	knockback_velocity = dir * knockback_strength
	
	var mat = sprite.material as ShaderMaterial
	if mat && !isDead:
		mat.set_shader_parameter("hit_flash", true)
		await get_tree().create_timer(0.1).timeout
		mat.set_shader_parameter("hit_flash", false)
	camera.screenShake(4, 0.3)
