extends CharacterBody2D
@export_category("Basics")
@export var health = 61

@onready var sprite: Sprite2D = $texture
@onready var isDead = false
@onready var colision: CollisionShape2D = $CollisionShape2D
@onready var camera = get_parent().get_node("Camera2D")
@onready var particles = $CPUParticles2D
@onready var particles2 = $CPUParticles2D2
@onready var ocluder = $LightOccluder2D
@onready var ocluder2 = $LightOccluder2D2
@onready var ocluder3 = $LightOccluder2D3

@onready var atualframe: int
@onready var oldframe: int

func _ready() -> void:
	if health > 50:
		sprite.frame = 0
	elif health < 50 && health > 40:
		sprite.frame = 1
	elif health < 40 && health > 30:
		sprite.frame = 2
	elif health < 30 && health > 20:
		sprite.frame = 3
		ocluder.set_deferred("visible",false)
		ocluder2.set_deferred("visible",true)
	elif health < 20 && health > 10:
		sprite.frame = 4
	elif health < 10 && health > 1:
		sprite.frame = 5
		ocluder2.set_deferred("visible",false)
		ocluder3.set_deferred("visible",true)
	elif health <1:
		sprite.frame = 6
		colision.set_deferred("disabled",true)
		ocluder3.set_deferred("visible",false)
		sprite.z_index = 0
	atualframe = sprite.frame
	oldframe = sprite.frame

func takeDamage(damage: int):
	hitFlash()
	
	
	health -= damage
	if health > 50:
		spritechange(0)
	elif health < 50 && health > 40:
		spritechange(1)
	elif health < 40 && health > 30:
		spritechange(2)
	elif health < 30 && health > 20:
		spritechange(3)
		ocluder.set_deferred("visible",false)
		ocluder2.set_deferred("visible",true)
	elif health < 20 && health > 10:
		spritechange(4)
	elif health < 10 && health > 1:
		spritechange(5)
		ocluder2.set_deferred("visible",false)
		ocluder3.set_deferred("visible",true)
	elif health <1:
		spritechange(6)
		colision.set_deferred("disabled",true)
		ocluder3.set_deferred("visible",false)
		sprite.z_index = 0
		
		
func spritechange(frame: int):
	oldframe = atualframe
	sprite.frame = frame
	atualframe = frame
	if oldframe != atualframe:
		camera.screenShake(10, 0.4)
		particles2.emitting = true
	else:
		camera.screenShake(3, 0.3)
		particles.emitting = true
		
	


func hitFlash():
	sprite.modulate = Color(0.6, 0.6, 0.6)
	await get_tree().create_timer(0.07).timeout
	sprite.modulate = Color.WHITE
