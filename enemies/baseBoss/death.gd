extends State
var stateMachine
@onready var camera: Camera2D = $"../../../Camera2D"
@onready var phantom: PhantomCamera2D = $"../../../PhantomCamera2D"
func enter():
	super.enter()
	owner.stateMachine.travel("idleDown")
	await get_tree().create_timer(0.5).timeout
	owner.set_physics_process(false)
	camera.screenShake(10, 4)
	await get_tree().create_timer(4).timeout
	
	owner.stateMachine.travel("death")
