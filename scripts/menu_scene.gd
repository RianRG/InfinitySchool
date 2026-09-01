extends Control

@onready var animation: AnimationPlayer = $VBoxContainer/AnimationPlayer
@onready var play: Button = $VBoxContainer/play
@onready var exit: Button = $VBoxContainer/exit
@onready var options_screen: Control = $OptionsMenu  # ajuste o path conforme sua árvore


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	options_screen.visible = false
	await get_tree().process_frame
	play.grab_focus()

func _on_start_button_pressed() -> void:
	Global.checkpointPos = Vector2(-999, -999)
	Global.prevCheckpointNode = null
	get_tree().change_scene_to_file("res://scenes/testecena.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_options_pressed() -> void:
	options_screen.open()
