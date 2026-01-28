extends Node2D
class_name Door

#@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var interactButton = $InteractButton

var is_open := false

func _input(event):
	if event.is_action_pressed("interact") and interactButton.canStartDialog:
		toggle()


func toggle():
	if not interactButton.canStartDialog:
		return

	is_open = !is_open

	if is_open:
		animation.play("open")
		#collision.disabled = true
	else:
		animation.play("closed")
		#collision.disabled = false
