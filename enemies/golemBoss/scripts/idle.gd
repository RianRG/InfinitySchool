extends State
@onready var collision: CollisionShape2D = $"../../playerDetection/CollisionShape2D"
var stateMachine

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

func transition():
	if playerEntered:
		get_parent().change_state("follow")


func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		get_parent().change_state("follow")
		
