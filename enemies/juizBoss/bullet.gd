extends Area2D
@onready var animation: AnimationPlayer = $AnimationPlayer

var speed:=100
var direction:=Vector2.RIGHT
func _physics_process(delta: float):
	position+=direction*speed*delta

#
   

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("character") and body.canTakeDamage:
		body.takeDamage(position, 500.0, 1)
		#body.freezeFrame(0, .15)	
		animation.play("explosion")


func _on_screen_exited() -> void:
	queue_free()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "explosion":
		queue_free()
