extends Button
class_name AnimatedButton

@export_category("Hover")
@export var hover_position: Vector2 = Vector2(0.0, -3.0)
@export var hover_animation_length: float = 0.1
@export var un_hover_animation_length: float = 0.1

@export_category("Press")
@export var press_scale: Vector2 = Vector2(0.95, 0.95)
@export var press_animation_length_1: float = 0.1
@export var press_animation_length_2: float = 0.1

var tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_button_press)
	mouse_entered.connect(_button_hover)
	mouse_exited.connect(_button_un_hover)
	
	focus_entered.connect(_button_hover)
	focus_exited.connect(_button_un_hover)
	pivot_offset_ratio = Vector2.ONE/2.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _button_press() -> void:
	if tween:
		tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "scale", press_scale, press_animation_length_1)
	tween.chain().tween_property(self, "scale", Vector2(1.0, 1.0), press_animation_length_2)
	
func _button_hover() -> void:
	if tween:
		tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", hover_position, hover_animation_length)
	
func _button_un_hover() -> void:
	if tween:
		tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", Vector2.ONE, un_hover_animation_length)
	
