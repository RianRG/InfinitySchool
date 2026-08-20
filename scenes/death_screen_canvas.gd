extends CanvasLayer

func _ready():
	layer = 21
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	var control = $Control
	control.set_anchors_preset(Control.PRESET_FULL_RECT)
	control.offset_left = 0
	control.offset_top = 0
	control.offset_right = 0
	control.offset_bottom = 0
	
	var vbox = $Control/VBoxContainer
	vbox.set_anchors_preset(Control.PRESET_CENTER)
	vbox.grow_horizontal = Control.GROW_DIRECTION_BOTH
	vbox.grow_vertical = Control.GROW_DIRECTION_BOTH
	
	print("=== DEBUG DEATHSCREEN ===")
	print("CanvasLayer layer: ", layer)
	print("CanvasLayer visible: ", visible)
	print("Control visible: ", control.visible)
	print("Control size: ", control.size)
	print("Control global_position: ", control.global_position)
	print("VBox visible: ", vbox.visible)
	print("VBox size: ", vbox.size)
	print("VBox global_position: ", vbox.global_position)
	print("VBox modulate: ", vbox.modulate)
