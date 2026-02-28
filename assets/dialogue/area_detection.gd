extends Area2D

var playerEntered: bool = false
@onready var interactButton: Node2D = $"../buttonSprite"
@onready var interactButtonFather: Node2D = $".."

@onready var door: Door = $"../.."



func _on_body_entered(body: Node2D) -> void:
	if body is Player and !playerEntered:
		playerEntered=true
		interactButtonFather.canStartDialog=true
		interactButton.appear()
		
		if door && door.ceilling && door.isOpen:
			var tween = create_tween()
			tween.tween_property(door.ceilling, "modulate:a", 0.0, 0.5)


func _on_body_exited(body: Node2D) -> void:
	if body is Player and playerEntered:
		playerEntered=false
		interactButtonFather.canStartDialog=false
		interactButton.disappear()
		
		if door && door.ceilling && !door.isOpen:
			var tween = create_tween()
			tween.tween_property(door.ceilling, "modulate:a", 1, 0.5)
		
