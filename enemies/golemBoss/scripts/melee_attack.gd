extends State


func enter():
	super.enter()
	owner.set_physics_process(true)
	animationPlayer.play("meleeAttack")
	
func transition():
	if owner.direction.length()>90:
		get_parent().change_state("follow")

func attackPlayer():
	player.takeDamage(owner.position)
