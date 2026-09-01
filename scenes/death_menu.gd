extends Control

@export var blur_target: float = 4.0

@onready var options_screen: Control = $PanelContainer/OptionsMenu


@onready var animation: AnimationPlayer = $PanelContainer/VBoxContainer/AnimationPlayer
@onready var play: Button = $PanelContainer/VBoxContainer/play
@onready var exit: Button = $PanelContainer/VBoxContainer/exit

func _ready() -> void:
	await get_tree().process_frame
	play.grab_focus()
	options_screen.visible = false
	pivot_offset = size / 2
	#visible = true
	$PanelContainer.material.set_shader_parameter("blur_amount", 0.0)



func _on_start_button_pressed() -> void:
	get_tree().paused=false
	close()
	Engine.time_scale=1.0
	
	get_tree().reload_current_scene()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_options_pressed() -> void:
	options_screen.open()




func open() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true

	visible = true
	modulate.a = 0.0
	scale = Vector2(0.9, 0.9)
	$PanelContainer.material.set_shader_parameter("blur_amount", 0.0)

	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 1.0, 0.25).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	


func close() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	tween.tween_property(self, "scale", Vector2(0.9, 0.9), 0.2)
	await tween.finished
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
