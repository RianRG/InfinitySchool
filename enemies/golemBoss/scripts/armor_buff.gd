extends State
var canTransition = false

func enter():
	super.enter()
	animationPlayer.play("armorBuff")
	await animationPlayer.animation_finished
	canTransition=true
	
func transition():
	if canTransition:
		canTransition = false
		get_parent().change_state("follow")
