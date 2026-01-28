extends Area2D

var playerEntered: bool = false
@onready var level: Level = $"../../Level"
@onready var interactButton: Node2D = $"../buttonSprite"
@onready var interactButtonFather: Node2D = $".."



func _on_body_entered(body: Node2D) -> void:
	if body is Player and !playerEntered:
		playerEntered=true
		interactButtonFather.canStartDialog=true
		interactButton.appear()
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	if body is Player and playerEntered:
		playerEntered=false
		interactButtonFather.canStartDialog=false
		interactButton.disappear()
	pass # Replace with function body.
