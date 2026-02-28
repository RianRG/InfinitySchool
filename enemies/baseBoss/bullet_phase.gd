extends State

@onready var bulletSpeedTimer: Timer = $"../../bulletSpeed"
@onready var bulletPhaseTimer: Timer = $"../../endBulletPhase"
@onready var _animationTree: AnimationTree = $"../../AnimationTree"
var timerIsOut:=false

var theta = 0.0
@export_range(0,2*PI) var alpha: float = 0.0
@onready var bulletScene: PackedScene = owner.bulletScene

var _active:=false

func enter():
	super.enter()
	_active=true
	_animationTree.set("parameters/conditions/timerIsOut", false)
	owner.cannotTakeKnockback=true
	bulletPhaseTimer.start(10)
	owner.stateMachine.travel("bulletPhaseStart")
	await get_tree().create_timer(1).timeout
	
	if !_active:
		return
	
	bulletSpeedTimer.start()

func exit():
	_active=false
	_animationTree.set("parameters/conditions/timerIsOut", false)
	bulletSpeedTimer.stop()
	bulletPhaseTimer.stop()
	owner.bulletPhaseDecided=false
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
	bullet.position = owner.global_position + Vector2(0, -50)
	bullet.direction= get_vector(angle)
	
	get_tree().current_scene.add_child(bullet)


func _on_bullet_speed_timeout() -> void:
	if !_active:
		return
	shoot(theta)
