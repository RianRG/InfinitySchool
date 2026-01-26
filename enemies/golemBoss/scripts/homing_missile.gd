extends State
@export var bulletNode: PackedScene
var canTransition = false

func enter():
	super.enter()
	animationPlayer.play("rangedAttack")
	await animationPlayer.animation_finished
	shoot()
	canTransition=true
func shoot():
	var bullet = bulletNode.instantiate()
	bullet.position = owner.position
	owner.get_parent().add_child(bullet)	
	bullet.z_index = 10

func transition():
	if canTransition:
		canTransition = false
		get_parent().change_state("dash")
