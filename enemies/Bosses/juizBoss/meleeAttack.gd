extends "res://enemies/baseBoss/meleeAttack.gd"

enum juizAttacks {
	MELEE,
	SPIN
}

func attackPlayer():
	var knockback_strength = 400.0 if currentAttack == juizAttacks.SPIN else 100.0
	player.takeDamage(owner.position, knockback_strength, 2)

func _on_attack_area_body_entered(body: Node2D):
	if body.is_in_group("quebravel"):
		body.takeDamage(18)


# ======================
# ATAQUES
# ======================

func spinAttack():
	currentAttack = juizAttacks.SPIN
	owner.knockback_velocity = owner.target_direction * 800
 

func endSpinAttack():
	owner.cannotTakeKnockback = false
	owner.speed = owner.slowSpeed
	owner.onAttackCooldown = true
	startAttackCooldown()
	cooldownAttackTimer.start()
	get_parent().change_state("follow")
