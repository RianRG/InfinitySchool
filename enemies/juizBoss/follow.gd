extends "res://enemies/baseBoss/follow.gd"

# phase
var chosenPhase=0
func enter():
	super.enter()
	owner.canMove=true
	owner.cannotTakeKnockback=false
	owner.stateMachine.travel("walk")


func transition():
	
	var distance = owner.position.distance_to(player.position)

	if distance<=135 && owner.direction != Vector2.ZERO && !owner.onAttackCooldown && timerIsOut:
		get_parent().change_state("meleeAttack")
		
	elif distance>150 && !owner.bulletPhaseDecided:
		var chosenPhase = 1
		if chosenPhase==1:	
			owner.bulletPhaseDecided=true
			get_parent().change_state("bulletPhase")
		


func _on_cooldown_attack_timeout() -> void:
	timerIsOut=true
