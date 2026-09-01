extends Line2D
class_name Trails

@export var MAX_LENGTH: int = 10
@export var subViewport: SubViewport
@export var parent: Node2D

@export var distanceAtLargestWidth: float = 16 * 6
@export var smallestTipWidth: float
@export var largestTipWidth: float

var length: float
var queue: Array[Vector2] = []
var offset: Vector2i

func _ready() -> void:
	offset = Vector2i(subViewport.size.x / 2, subViewport.size.y / 2)

func _process(delta: float) -> void:
	length = 0.0
	print(parent.global_position)
	var pos: Vector2 = parent.global_position + Vector2(offset)
	queue.append(pos)
	if queue.size() > MAX_LENGTH and queue.size() > 2:
		queue.pop_front()

	clear_points()

	for i in range(queue.size() - 1):
		length += queue[i].distance_to(queue[i + 1])
		add_point(parent.to_local(queue[i]))
	add_point(parent.to_local(queue[queue.size() - 1]))

	var width_value: float = lerp(smallestTipWidth, largestTipWidth, inverse_lerp(0.0, distanceAtLargestWidth, length))
	width_curve.set_point_value(0, width_value)

func reset_line() -> void:
	clear_points()
	queue.clear()
