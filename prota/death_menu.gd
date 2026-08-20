extends "res://scripts/menu_scene.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	
	for node in get_tree().get_nodes_in_group("whiteout_layer"):
		node.queue_free()
	
	get_tree().reload_current_scene()
