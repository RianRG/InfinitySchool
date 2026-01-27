extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var player = get_parent().find_child("player")
var direction: Vector2
var DEF=0

var knockback_velocity: Vector2 = Vector2.ZERO
var knockback_decay := 700.0 # quanto maior, mais rápido ele "freia"

var health=100:
	set(value):
		health=value
		if value==0:
			find_child("FiniteStateMachine").change_state("death")
		elif value<=50 && DEF==0:
			DEF=5
			find_child("FiniteStateMachine").change_state("armorBuff")

func _ready():
	set_physics_process(false)
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

func _process(delta):
	direction = player.position-position
	
	if direction.x<0 && health>0:
		sprite.flip_h=true
	elif direction.x>=0 && health>0:
		sprite.flip_h=false

func _physics_process(delta):
	var move_velocity = direction.normalized()*100
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_decay * delta)
	velocity = move_velocity + knockback_velocity
	move_and_slide()
	
func takeDamage():
	# Reduz a vida
	health -= 10 - DEF
	
	# --- Knockback ---
	var direction_from_player = (global_position - player.position).normalized()
	var knockback_strength = 300.0
	knockback_velocity = direction_from_player * knockback_strength
	
	var mat = sprite.material as ShaderMaterial
	if mat && health>0:
		mat.set_shader_parameter("hit_flash", true)
		await get_tree().create_timer(0.1).timeout # dura 0.1s
		mat.set_shader_parameter("hit_flash", false)
	
