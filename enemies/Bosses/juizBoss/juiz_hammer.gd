extends CharacterBody2D

@onready var toRetreatTimer: Timer = $toRetreat
@onready var camera: Camera2D = $"../Camera2D"

@onready var vfxAnimation: AnimationPlayer = $HammerVFXAnimation

@onready var baseframe: Sprite2D = $HammerBase
@onready var toAttackTimer: Timer = $toAttack
@onready var animation: AnimationPlayer = $AnimationPlayer
enum PossibleAttacks {
	X, PLUS
}
var attackcounter = 0
var currentAttack = PossibleAttacks.X
#func _physics_process(delta: float) -> void:
#

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		body.takeDamage(global_position, 400.0, 3)
		
		body.freezeFrame(0.01, 0.3)
		


func _on_to_attack_timeout() -> void:
	if currentAttack == PossibleAttacks.X:
		vfxAnimation.play("X")
		currentAttack = PossibleAttacks.PLUS
	else:
		vfxAnimation.play("+")
		currentAttack = PossibleAttacks.X
	await get_tree().create_timer(.4).timeout
	animation.play("attack")
	await get_tree().create_timer(2).timeout
	animation.play("reset")
	toAttackTimer.start(6.5) 


func attack():
	camera.screenShake(15, 0.5)
	attackcounter += 1
	if attackcounter == 2:
		baseframe.frame = 1
	if attackcounter == 18:
		baseframe.frame = 2
	if attackcounter == 20:
		baseframe.frame = 3

func stop():
	toAttackTimer.stop()
	toRetreatTimer.stop()
#func _on_hammer_vfx_animation_animation_finished(anim_name: StringName) -> void:
	#if anim_name == "X":
		#print()


func _on_vfx_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		body.takeDamage(global_position, 200.0, 4)
		
		body.freezeFrame(0.02, 0.2)
