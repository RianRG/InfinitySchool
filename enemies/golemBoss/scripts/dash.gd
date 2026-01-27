extends State
var canTransition = false


func enter():
	super.enter()
	animationPlayer.play("glowing")
	await dash()
	canTransition=true

func dash():
	var tween = create_tween()
	owner.set_physics_process(true)
	tween.tween_property(owner, "position", player.position, 0.8)
	await tween.finished


func transition():
	if canTransition:
		canTransition=false
		
		get_parent().change_state("follow")
