extends State
var stateMachine

func enter():
	super.enter()
	owner.onState = true
	owner.set_physics_process(false)
	owner.stateMachine.travel("attack")
	await get_tree().create_timer(0.8).timeout
	owner.onState=false
	
func transition():
	if owner.direction.length()>120:
		get_parent().change_state("follow")

func attackPlayer():
	player.takeDamage(owner.position)


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		attackPlayer()
