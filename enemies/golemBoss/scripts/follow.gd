extends State
@onready var animation: AnimationPlayer = $"../../AnimationPlayer"
func enter():
	super.enter()
	
	owner.onState=false
	owner.stateMachine.travel("walk")

func exit():
	super.exit()
	#owner.set_physics_process(false)

func transition():
	var distance = owner.direction.length()
	if distance<=140 && owner.direction != Vector2.ZERO && !owner.onAttackCooldown:
		get_parent().change_state("meleeAttack")
		
	# ataque a distância
	#elif distance>130:
		#var chance = randi()%2
		#match chance:
			#0:
				#get_parent().change_state("homingMissile")
			#1: 
				#get_parent().change_state("laser")
