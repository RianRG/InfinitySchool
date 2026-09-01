extends State
var stateMachine
func enter():
	super.enter()
	animationPlayer.play("death")
	await animationPlayer.animation_finished
