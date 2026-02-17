extends State

@onready var bulletPhaseTimer: Timer = $"../../endBulletPhase"
@onready var _animationTree: AnimationTree = $"../../AnimationTree"
var timerIsOut:=false

func enter():
	super.enter()
	_animationTree.set("parameters/conditions/timerIsOut", false)
	bulletPhaseTimer.start(4)
	owner.cannotTakeKnockback=true
	owner.stateMachine.travel("bulletPhaseStart")

func exit():
	_animationTree.set("parameters/conditions/timerIsOut", false)
	
	super.exit()

func transition():
	pass

func _on_end_bullet_phase_timeout() -> void:
	_animationTree.set("parameters/conditions/timerIsOut", true)

func endBulletPhase():
	print("=== END BULLET PHASE CHAMADO ===")
	_animationTree.set("parameters/conditions/timerIsOut", false)
	owner.cannotTakeKnockback=false
	get_parent().change_state("follow")
