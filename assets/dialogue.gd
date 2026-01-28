extends Control
class_name DialogueScreen

var step := 0.05
var id := 0
var data: Dictionary = {}
var typing := false
var typing_id := 0

@onready var _name: Label = $Background/HContainer/VContainer/Name
@onready var _dialog: RichTextLabel = $Background/HContainer/VContainer/RichTextLabel

func start(dialog_data: Dictionary) -> void:
	data = dialog_data
	id = 0
	_show_dialog()

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if typing:
			_dialog.visible_characters = _dialog.text.length()
			typing = false
		else:
			id += 1
			if id >= data.size():
				queue_free()
				return
			_show_dialog()

func _show_dialog():
	typing_id += 1
	var local_id = typing_id
	typing = true

	_name.text = data[id]["title"]
	_dialog.text = data[id]["dialog"]
	_dialog.visible_characters = 0

	while _dialog.visible_characters < _dialog.text.length():
		if local_id != typing_id:
			return
		await get_tree().create_timer(step).timeout
		_dialog.visible_characters += 1

	typing = false
