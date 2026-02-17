extends "res://enemies/baseBoss/meleeAttack.gd"

enum attacksEnum { MELEE, SPIN }

func enter():
	super.enter()
	owner.cannotTakeKnockback = true  # Bloqueia knockback durante ataque
	owner.canMove=true
	owner.stateMachine.travel("attack")

func transition():
	var distance = owner.position.distance_to(player.position)
	if distance > 180 and !owner.cannotTakeKnockback:
		get_parent().change_state("follow")


func attackPlayer():
	var knockback_strength = 500.0 if currentAttack == attacksEnum.SPIN else 200.0
	player.takeDamage(owner.position, knockback_strength)


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		attackPlayer()


# ======================
# ATAQUES
# ======================

func spinAttack():
	currentAttack = attacksEnum.SPIN
	owner.knockback_velocity = owner.target_direction * 800
 

func endSpinAttack():
	owner.cannotTakeKnockback = false
	owner.speed = 90
	owner.onAttackCooldown = true
	startAttackCooldown()
	cooldownAttackTimer.start()
	get_parent().change_state("follow")
