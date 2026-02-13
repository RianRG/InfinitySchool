extends State
@onready var collision: CollisionShape2D = $"../../playerDetection/CollisionShape2D"
var stateMachine

var playerEntered = false:
	set(value):
		playerEntered=true
		collision.set_deferred("disabled", value)

func transition():
	if playerEntered:
		get_parent().change_state("follow")


func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		playerEntered=true
