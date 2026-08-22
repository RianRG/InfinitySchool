extends CanvasLayer

@onready var control: Control = $Control
@onready var vbox: VBoxContainer = $Control/VBoxContainer

func _ready():
	layer = 21
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	control.set_anchors_preset(Control.PRESET_FULL_RECT)
	control.offset_left = 0
	control.offset_top = 0
	control.offset_right = 0
	control.offset_bottom = 0
	
	# espera o layout assentar antes de centralizar
	await get_tree().process_frame
	
	vbox.set_anchors_preset(Control.PRESET_CENTER)
	vbox.grow_horizontal = Control.GROW_DIRECTION_BOTH
	vbox.grow_vertical = Control.GROW_DIRECTION_BOTH
	
	# estado inicial para a animação de entrada
	vbox.modulate.a = 0.0
	vbox.scale = Vector2(0.85, 0.85)
	vbox.pivot_offset = vbox.size / 2.0

func show_menu(duration := 0.4):
	visible = true
	vbox.modulate.a = 0.0
	vbox.scale = Vector2(0.85, 0.85)
	vbox.pivot_offset = vbox.size / 2.0
	
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(vbox, "modulate:a", 1.0, duration)
	tween.tween_property(vbox, "scale", Vector2.ONE, duration)
