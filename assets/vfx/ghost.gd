extends Sprite2D

func _ready() -> void:
	fading()
	
func setframe(frame1):
	frame = frame1

func fading():
	var tween_fade = get_tree().create_tween()
	tween_fade.tween_property(self,"self_modulate",Color(1,1,1,0),.4)
	await tween_fade.finished
	queue_free()
