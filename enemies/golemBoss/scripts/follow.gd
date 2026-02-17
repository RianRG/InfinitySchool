extends State
@onready var animation: AnimationPlayer = $"../../AnimationPlayer"
@onready var cooldownAttackTimer: Timer = $"../../cooldownAttack"

var timerIsOut:=false
# phase
var phaseDecided:=false
var chosenPhase=0
func enter():
	super.enter()
	owner.canMove=true
	phaseDecided=true
	owner.cannotTakeKnockback=false
	phaseDecided=false
	owner.stateMachine.travel("walk")

func exit():
	super.exit()
	#owner.set_physics_process(false)

func transition():
	var distance = owner.position.distance_to(player.position)

	if distance<=120 && owner.direction != Vector2.ZERO && !owner.onAttackCooldown && timerIsOut:
		get_parent().change_state("meleeAttack")
		
	elif distance>130 && !phaseDecided:
		var chosenPhase = randi()%3
		phaseDecided=true
		if chosenPhase==1:	
			get_parent().change_state("bulletPhase")
		


func _on_cooldown_attack_timeout() -> void:
	timerIsOut=true
