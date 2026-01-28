extends Area2D

var playerEntered: bool = false
@onready var interactButton: Node2D = $"../InteractButton"
@onready var level: Level = $"../../Level"




func _on_body_entered(body: Node2D) -> void:
	if body is Player and !playerEntered:
		level.canStartDialog=true
		playerEntered=true
		interactButton.appear()
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	if body is Player and playerEntered:
		level.canStartDialog=false
		playerEntered=false
		interactButton.disappear()
	pass # Replace with function body.
