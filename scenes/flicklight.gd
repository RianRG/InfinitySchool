extends PointLight2D
@export var speed: float = 1
@export var offchance: int = 4

func _ready() -> void:
	while true:
		var on = randi()%offchance
		if on == 1:
			enabled = false
		else:
			enabled = true
		await get_tree().create_timer(0.1*speed).timeout
