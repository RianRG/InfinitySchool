extends Node2D

# escala dele comeca no 0 por padrao
func appear():
	scale = Vector2.ZERO
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", Vector2(0.4, 0.4), 0.3)

func disappear():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.3)
