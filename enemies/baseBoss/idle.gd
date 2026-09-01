extends State
@onready var animation: AnimationPlayer = $"../../AnimationPlayer"
@onready var collision: CollisionShape2D = $"../../playerDetection/CollisionShape2D"


var playerEntered = false:
	set(value):
		playerEntered=true
		collision.set_deferred("disabled", value)

func enter():
	super.enter()
	owner.canMove=false
	owner.knockback_velocity=Vector2.ZERO
	owner.direction = Vector2.ZERO
	owner.target_direction = Vector2.ZERO
	#owner.stateMachine.travel("walk")
