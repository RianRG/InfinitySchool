extends PointLight2D
@export var speed: float = 1
@export var offchance: int = 4

func _ready() -> void:
	while is_inside_tree():
		var on = randi() % offchance
		enabled = (on != 1)
		await get_tree().create_timer(0.1 * speed).timeout
