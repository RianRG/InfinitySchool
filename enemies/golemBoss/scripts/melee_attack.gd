extends State

@onready var cooldownAttackTimer: Timer = $"../../cooldownAttack"
var stateMachine
enum attacksEnum { MELEE, SPIN }
var currentAttack: attacksEnum

func enter():
	super.enter()
	owner.onState = true  # Bloqueia knockback durante ataque
	owner.stateMachine.travel("attack")

func transition():
	var distance = owner.position.distance_to(player.position)
	if distance > 180 and !owner.onState:
		get_parent().change_state("follow")


func attackPlayer():
	var knockback_strength = 500.0 if currentAttack == attacksEnum.SPIN else 200.0
	player.takeDamage(owner.position, knockback_strength)


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		attackPlayer()


func startAttackCooldown():
	await get_tree().create_timer(2).timeout
	owner.speed = 160
	owner.onAttackCooldown = false
	owner.knockback_velocity = Vector2.ZERO


# ======================
# ATAQUES
# ======================
func dashAttack():
	currentAttack = attacksEnum.MELEE
	owner.onState = true
	
	# Dash define a direção e a velocidade do boss
	owner.target_direction = (player.position - owner.global_position).normalized()
	owner.knockback_velocity = owner.target_direction * 400  # velocidade do dash


func spinAttack():
	currentAttack = attacksEnum.SPIN
	owner.knockback_velocity = owner.target_direction * 800
 

func endSpinAttack():
	owner.onState = false
	owner.speed = 90
	owner.onAttackCooldown = true
	startAttackCooldown()
	cooldownAttackTimer.start()
	get_parent().change_state("follow")
