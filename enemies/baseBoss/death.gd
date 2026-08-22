extends State
var stateMachine
@onready var camera: Camera2D = $"../../../Camera2D"
@onready var phantom: PhantomCamera2D = $"../../../PhantomCamera2D"
@onready var scream: AudioStreamPlayer = $"../../BossScream"

func enter():
	super.enter()
	owner.cannotTakeKnockback=false
	var direction_from_player = (owner.global_position - owner.player.global_position).normalized()
	
	owner.stateMachine.travel("idleDown")
	await get_tree().create_timer(0.5).timeout
	scream.play()
	owner.set_physics_process(false) 
	camera.screenShake(10, 4)
	await get_tree().create_timer(2).timeout
	
	owner.stateMachine.travel("death")
