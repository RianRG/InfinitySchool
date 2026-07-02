extends CharacterBody2D
@export_category("Basics")
@export var health = 64

@onready var sprite: Sprite2D = $texture
@onready var isDead = false
@onready var colision: CollisionShape2D = $CollisionShape2D
@onready var camera = get_parent().get_node("Camera2D")
@onready var particles = $CPUParticles2D
@onready var ocluder = $LightOccluder2D

func _ready() -> void:
	if health > 30:
		sprite.frame = 0
	elif health < 30 && health > 1:
		sprite.frame = 1
	elif health <1:
		sprite.frame = 2
		colision.set_deferred("disabled",true)
	

func takeDamage(damage: int):
	camera.screenShake(5, 0.3)
	particles.emitting = true
	hitFlash()
	
	health -= damage
	if health > 15:
		sprite.frame = 0
	elif health < 15 && health > 1:
		camera.screenShake(10, 0.3)
		sprite.frame = 1
	elif health <1:
		camera.screenShake(15, 0.3)
		sprite.frame = 2
		colision.set_deferred("disabled",true)
		ocluder.set_deferred("visible",false)
		
func hitFlash():
	sprite.modulate = Color(0.6, 0.6, 0.6)
	await get_tree().create_timer(0.07).timeout
	sprite.modulate = Color.WHITE
