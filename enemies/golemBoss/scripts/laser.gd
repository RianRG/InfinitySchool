extends State
@onready var pivot: Node2D = $"../../pivot"
var canTransition = false

func enter():
	super.enter()
	await play_animation("laserCast")
	await play_animation("laser")
	canTransition=true
func play_animation(animName):
	animationPlayer.play(animName)
	await animationPlayer.animation_finished


func set_target():
	pivot.rotation = (owner.direction - pivot.position).angle()


func transition():
	if canTransition:
		canTransition=false
		get_parent().change_state("dash")
