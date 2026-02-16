extends State

@onready var bulletPhaseTimer: Timer = $"../../endBulletPhase"
@onready var _animationTree: AnimationTree = $"../../AnimationTree"
var timerIsOut:=false

func enter():
	super.enter()
	print("=== ENTROU BULLET PHASE ===")
	_animationTree.set("parameters/conditions/timerIsOut", false)
	bulletPhaseTimer.start(4)
	owner.canMove=false
	owner.onState=true
	owner.stateMachine.travel("bulletPhaseStart")

func exit():
	super.exit()
	print("=== SAIU BULLET PHASE ===")

func transition():
	pass



func _on_end_bullet_phase_timeout() -> void:
	_animationTree.set("parameters/conditions/timerIsOut", true)

func endBulletPhase():
	print("=== END BULLET PHASE CHAMADO ===")
	_animationTree.set("parameters/conditions/timerIsOut", false)
	owner.onState=false
	get_parent().change_state("follow")
