extends Control
class_name DialogueScreen

var step: float = 0.05
var id = 0
var data: Dictionary = {}
@export_category("Objects")
@onready var _name: Label = $Background/HContainer/VContainer/Name
@onready var _dialog: RichTextLabel = $Background/HContainer/VContainer/RichTextLabel

func _ready() -> void:
	_initializeDialog()
	
func _process(delta: float):
	if Input.is_action_pressed("ui_accept") and _dialog.visible_characters<1:
		step=0.01
		return
	step=0.05
	if Input.is_action_just_pressed("ui_accept"):
		id+=1
		if id==data.size():
			queue_free()
			return
		_initializeDialog()
	
func _initializeDialog() -> void:
	_name.text = data[id]["title"]
	_dialog.text = data[id]["dialog"]
	
	_dialog.visible_characters=0
	while _dialog.visible_ratio<1:
		await get_tree().create_timer(step)
		_dialog.visible_characters+=1
		
