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


func dashAttack():
	owner.onState = true
	
	# Calcula direção UMA VEZ
	owner.dash_direction = (player.position - global_position).normalized()
	owner.knockback_velocity = owner.dash_direction * 400

func spinAttack():
	# Recalcula direção apenas no início do segundo dash
	owner.dash_direction = (player.position - global_position).normalized()
	owner.knockback_velocity = owner.dash_direction * 800


func endSpinAttack():
	owner.onState = false
	owner.speed = 60
	owner.onAttackCooldown = true
	
	startAttackCooldown()
	find_child("FiniteStateMachine").change_state("follow")


func startAttackCooldown():
	await get_tree().create_timer(0.5).timeout
	owner.speed = 160
	owner.onAttackCooldown = false
