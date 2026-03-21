extends "res://enemies/baseBoss/follow.gd"

var phaseRolled:=false

func enter():
	super.enter()
	phaseRolled=false
	owner.canMove=true
	owner.cannotTakeKnockback=false
	owner.stateMachine.travel("walk")


func transition():
	
	var distance = owner.position.distance_to(player.position)
	if distance<=135 && owner.direction != Vector2.ZERO && !owner.onAttackCooldown && timerIsOut:
		get_parent().change_state("meleeAttack")
		
	elif distance>150 && !owner.bulletPhaseDecided && !phaseRolled:
		phaseRolled=true
		var chosenPhase = randi()%5
		if chosenPhase==1:	
			owner.bulletPhaseDecided=true
			get_parent().change_state("bulletPhase")
		


func _on_cooldown_attack_timeout() -> void:
	timerIsOut=true
