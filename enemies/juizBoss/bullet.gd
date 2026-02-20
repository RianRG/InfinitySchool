extends Area2D

var speed:=100
var direction:=Vector2.RIGHT
func _physics_process(delta: float):
	position+=direction*speed*delta


func _on_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		body.takeDamage(position, 200.0, 1)
