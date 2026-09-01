extends ScrollContainer

@export var text_node : Control
@export_range(1, 500, 1) var scroll_speed : float = 40.0
@export_range(0.1, 5.0, 0.1) var fade_in_duration : float = 1.5

@onready var margin : MarginContainer = $MarginContainer

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	modulate.a = 0.0  # esconde tudo enquanto o layout se ajusta

	await get_tree().process_frame
	await get_tree().process_frame

	var container_size : float = size.y
	var text_box_size : float = text_node.size.y

	margin.add_theme_constant_override("margin_top", int(container_size))
	margin.add_theme_constant_override("margin_bottom", int(container_size))

	await get_tree().process_frame
	await get_tree().process_frame

	scroll_vertical = 0  # força começar do zero, ignorando qualquer valor intermediário

	await get_tree().process_frame  # garante que o scroll_vertical=0 foi aplicado visualmente

	# fade suave de opacidade, revelando os créditos aos poucos
	var fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate:a", 1.0, fade_in_duration)

	var scroll_amount : int = ceil(container_size + text_box_size)
	var duration : float = scroll_amount / scroll_speed

	var tween = create_tween()
	tween.tween_property(self, "scroll_vertical", scroll_amount, duration)
	tween.finished.connect(_acabou)


func fade_out_audio(bus_name := "Master", duration := 1.0, target_db := -40.0):
	var bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		return

	var original_db = AudioServer.get_bus_volume_db(bus_index)
	var tween = create_tween()
	tween.tween_method(
		func(db): AudioServer.set_bus_volume_db(bus_index, db),
		original_db,
		target_db,
		duration
	)


func _acabou() -> void:
	fade_out_audio()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/menu_scene.tscn")


func _on_timer_timeout() -> void:
	fade_out_audio()
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/menu_scene.tscn")
