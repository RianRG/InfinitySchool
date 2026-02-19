extends State

@onready var bulletPhaseTimer: Timer = $"../../endBulletPhase"
@onready var _animationTree: AnimationTree = $"../../AnimationTree"
var timerIsOut:=false

var theta = 0.0
@export_range(0,2*PI) var alpha: float = 0.0
@onready var bulletScene: PackedScene = owner.bulletScene

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

func get_vector(angle):
	theta = angle+alpha
	return Vector2(cos(theta), sin(theta))
	 
func shoot(angle):
	var bullet = bulletScene.instantiate()
	bullet.position = owner.global_position
	bullet.direction= get_vector(angle)
	
	get_tree().current_scene.call_deferred("add_child", bullet)


func _on_bullet_speed_timeout() -> void:
	shoot(theta)
