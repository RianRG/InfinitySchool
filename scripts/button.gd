extends Button
class_name AnimatedButton

@export_category("Hover")
@export var hover_scale: Vector2 = Vector2(1.05, 1.05)
@export var hover_animation_length: float = 0.1

@export_category("Press")
@export var press_scale: Vector2 = Vector2(0.95, 0.95)
@export var press_animation_length: float = 0.08

@export_category("Focus")
@export var default_focus: bool = false

var tween: Tween


func _ready() -> void:
	pivot_offset = size / 2.0
	resized.connect(func(): pivot_offset = size / 2.0)

	pressed.connect(_on_pressed)
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_unhover)
	focus_entered.connect(_on_hover)
	focus_exited.connect(_on_unhover)

	if default_focus:
		call_deferred("grab_focus")


func _animate_scale(target: Vector2, duration: float) -> void:
	if tween:
		tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", target, duration)


func _on_hover() -> void:
	_animate_scale(hover_scale, hover_animation_length)


func _on_unhover() -> void:
	_animate_scale(Vector2.ONE, hover_animation_length)


func _on_pressed() -> void:
	_animate_scale(press_scale, press_animation_length)

	if not is_inside_tree():
		return

	var tree := get_tree()

	if tree == null:
		return

	await tree.create_timer(press_animation_length).timeout

	if not is_inside_tree():
		return

	_animate_scale(
		hover_scale if is_hovered() else Vector2.ONE,
		press_animation_length
	)
