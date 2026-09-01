extends Control

@export var blur_target: float = 4.0

@onready var volumeSlider: HSlider = $PanelContainer/VBoxContainer/HBoxContainer/volume
@onready var resolutions: OptionButton = $PanelContainer/VBoxContainer/HBoxContainer2/Resolutions
@onready var bindsContainer: PanelContainer = $PanelContainer2
@onready var mainContainer: PanelContainer = $PanelContainer
@onready var seeBindsButton: AnimatedButton = $PanelContainer/VBoxContainer/ButtonSlot/seeBinds
@onready var close2Button: AnimatedButton = $PanelContainer2/VBoxContainer/ButtonSlot/close2


func _ready() -> void:
	pivot_offset = size / 2
	visible = false
	bindsContainer.visible=false
	$PanelContainer.material.set_shader_parameter("blur_amount", 0.0)
	
	var audio_settings = ConfigFileHandler.load_audio_settings()
	volumeSlider.value = min(audio_settings.master_volume, 1.0)*100


func open() -> void:
	visible = true
	seeBindsButton.grab_focus()
	modulate.a = 0.0
	scale = Vector2(0.9, 0.9)
	$PanelContainer.material.set_shader_parameter("blur_amount", 0.0)

	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 1.0, 0.25).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_method(_set_blur, 0.0, blur_target, 0.25).set_trans(Tween.TRANS_SINE)


func close() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	tween.tween_property(self, "scale", Vector2(0.9, 0.9), 0.2)
	tween.tween_method(_set_blur, blur_target, 0.0, 0.2).set_trans(Tween.TRANS_SINE)
	await tween.finished
	visible = false
	


func _set_blur(value: float) -> void:
	$PanelContainer.material.set_shader_parameter("blur_amount", value)


func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
	ConfigFileHandler.save_audio_settings("master_volume", volumeSlider.value/100)

func _on_resolutions_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600, 900))
		2:
			DisplayServer.window_set_size(Vector2i(1280, 720))
		3:
			DisplayServer.window_set_size(Vector2i(640, 360))


func _on_close_button_pressed() -> void:
	close()


func _on_see_binds_pressed() -> void:
	bindsContainer.visible=true
	mainContainer.visible=false
	close2Button.grab_focus()


func _on_close_2_pressed() -> void:
	bindsContainer.visible=false
	mainContainer.visible=true
	seeBindsButton.grab_focus()
