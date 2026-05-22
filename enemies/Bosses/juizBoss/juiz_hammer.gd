extends CharacterBody2D

@onready var toRetreatTimer: Timer = $toRetreat
@onready var camera: Camera2D = $"../Camera2D"

@onready var vfxAnimation: AnimationPlayer = $HammerVFXAnimation

@onready var toAttackTimer: Timer = $toAttack
@onready var animation: AnimationPlayer = $AnimationPlayer

#func _physics_process(delta: float) -> void:
#

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		body.takeDamage(global_position, 400.0, 3)
		
		body.freezeFrame(0.5, .7)
		


func _on_to_attack_timeout() -> void:
	
	vfxAnimation.play("X")
	await get_tree().create_timer(.4).timeout
	animation.play("attack")
	await get_tree().create_timer(2).timeout
	animation.play("reset")
	toAttackTimer.start(10) 


func attack():
	camera.screenShake(10, 0.5)


#func _on_hammer_vfx_animation_animation_finished(anim_name: StringName) -> void:
	#if anim_name == "X":
		#print()


func _on_vfx_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		body.takeDamage(global_position, 200.0, 3)
		
		body.freezeFrame(0.5, .7)
	pass # Replace with function body.
