extends CanvasLayer

@onready var control: Control = $Control
@onready var vbox: VBoxContainer = $Control/VBoxContainer


func _ready():
	layer = 21
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false


func show_menu(duration := 0.4):
	visible = true
	vbox.pivot_offset = vbox.size / 2.0

	vbox.modulate.a = 0.0
	vbox.scale = Vector2(0.85, 0.85)

	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(vbox, "modulate:a", 1.0, duration)
	tween.tween_property(vbox, "scale", Vector2.ONE, duration)
