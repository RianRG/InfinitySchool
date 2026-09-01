extends Area2D
class_name DoorComponent

@export_category("Variables")
@export var teleportPosition: Vector2

@export var animationPlayer: AnimationPlayer
var player: Player=null

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player=body
		animationPlayer.play("attack")
		print("ok")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	animationPlayer.play("idle")
	if player:
		player.global_position=teleportPosition


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player=null
