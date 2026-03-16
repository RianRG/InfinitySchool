extends CharacterBody2D

@onready var toRetreatTimer: Timer = $toRetreat
@onready var camera: Camera2D = $"../Camera2D"

@onready var toAttackTimer: Timer = $toAttack
@onready var animation: AnimationPlayer = $AnimationPlayer

#func _physics_process(delta: float) -> void:
#

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		body.takeDamage(global_position, 500.0, 3)
		camera.screenShake(5, 0.5)
		body.freezeFrame(0.3, 1.0)
		


func _on_to_attack_timeout() -> void:
	animation.play("attack")
	await get_tree().create_timer(3).timeout
	animation.play("reset")
	toAttackTimer.start() 
