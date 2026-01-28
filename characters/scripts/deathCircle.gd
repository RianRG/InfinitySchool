@tool
extends Sprite2D

var alphaCircle: float = 100.0

func _draw():
	draw_circle(Vector2.ZERO, 100, Color(1, 1, 1, alphaCircle))
func _ready():
	position.y = -40
