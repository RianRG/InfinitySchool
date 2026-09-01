extends Sprite2D

@onready var marker: Marker2D = $Marker2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_sprite()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.is_in_group("character")):
		Global.checkpointPos = marker.global_position
		if Global.prevCheckpointNode:
			Global.prevCheckpointNode._update_sprite()
		Global.prevCheckpointNode = self
		_update_sprite()

func _update_sprite():
	if marker.global_position == Global.checkpointPos:
		frame = 1
	else:
		frame = 0
