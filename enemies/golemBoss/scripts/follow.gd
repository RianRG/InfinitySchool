extends State
@onready var animation: AnimationPlayer = $"../../AnimationPlayer"
@onready var cooldownAttackTimer: Timer = $"../../cooldownAttack"

var timerIsOut:=false

func enter():
	super.enter()
	owner.set_physics_process(true)
	
	owner.onState=false
	owner.stateMachine.travel("walk")

func exit():
	super.exit()
	#owner.set_physics_process(false)

func transition():
	var distance = owner.position.distance_to(player.position)

	if distance<=100 && owner.direction != Vector2.ZERO && !owner.onAttackCooldown && timerIsOut:
		get_parent().change_state("meleeAttack")
		
	# ataque a distância
	#elif distance>130:
		#var chance = randi()%2
		#match chance:
			#0:
				#get_parent().change_state("homingMissile")
			#1: 
				#get_parent().change_state("laser")


func _on_cooldown_attack_timeout() -> void:
	timerIsOut=true
