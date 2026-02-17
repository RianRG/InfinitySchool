extends State
@onready var animation: AnimationPlayer = $"../../AnimationPlayer"
@onready var cooldownAttackTimer: Timer = $"../../cooldownAttack"

var timerIsOut:=false
func enter():
	super.enter()
	owner.canMove=true
	owner.cannotTakeKnockback=false
	owner.stateMachine.travel("walk")

func exit():
	super.exit()
	#owner.set_physics_process(false)

func transition():
	var distance = owner.position.distance_to(player.position)

	if distance<=120 && owner.direction != Vector2.ZERO && !owner.onAttackCooldown && timerIsOut:
		get_parent().change_state("meleeAttack")
		


func _on_cooldown_attack_timeout() -> void:
	timerIsOut=true
