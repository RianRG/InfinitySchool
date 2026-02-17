extends "res://enemies/baseBoss/meleeAttack.gd"

enum juizAttacks {
	MELEE,
	SPIN
}

func attackPlayer():
	var knockback_strength = 500.0 if currentAttack == juizAttacks.SPIN else 200.0
	player.takeDamage(owner.position, knockback_strength)


# ======================
# ATAQUES
# ======================

func spinAttack():
	currentAttack = juizAttacks.SPIN
	owner.knockback_velocity = owner.target_direction * 800
 

func endSpinAttack():
	owner.cannotTakeKnockback = false
	owner.speed = 90
	owner.onAttackCooldown = true
	startAttackCooldown()
	cooldownAttackTimer.start()
	get_parent().change_state("follow")
