extends State
var stateMachine

func enter():
	super.enter()
	owner.onState = true
	owner.stateMachine.travel("attack")
	
func transition():
	var distance = owner.direction.length()
	if distance>180 && !owner.onState:
		get_parent().change_state("follow")

func attackPlayer():
	player.takeDamage(owner.position, 40.0)


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		attackPlayer()
