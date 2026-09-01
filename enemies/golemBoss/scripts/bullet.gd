extends Area2D
@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player = get_parent().find_child("player")

var acc = Vector2.ZERO
var velocity = Vector2.ZERO

func _physics_process(delta):
	acc = (player.position - position).normalized() * 700
	
	velocity+=acc*delta
	rotation = velocity.angle()
	
	velocity=velocity.limit_length(150)
	
	position+=velocity*delta



func _on_detection_body_entered(body: Node2D) -> void:
	queue_free()
