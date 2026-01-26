extends State

func enter():
	super.enter()
	animationPlayer.play("death")
	await animationPlayer.animation_finished
