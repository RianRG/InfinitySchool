extends Control
class_name DialogueScene

var step := 0.05
var id := 0
var data: Dictionary = {}
var typing := false
var typing_id := 0
var player = null
@onready var _name: Label = $DialogueScreen/Background/HContainer/VContainer/Name
@onready var _dialog: RichTextLabel = $DialogueScreen/Background/HContainer/VContainer/RichTextLabel
@onready var animation: AnimationPlayer = $AnimationPlayer

@onready var sprite: Sprite2D = $sprite



@onready var tween: Tween = get_tree().create_tween()

func start(dialog_data: Dictionary) -> void:
	Global.dialogueActive=true
	#player=pPlayer
	#player.set_physics_process(false)
	data = dialog_data
	id = 0
	
	# efeito de zoom
	animation.play("enter")
	
	_show_dialog()

func _process(delta):
	if Input.is_action_pressed("ui_accept") and _dialog.visible_ratio<1 and _dialog.visible_characters>3:
		_dialog.visible_characters = _dialog.text.length()
		return
	step=0.05
	if Input.is_action_just_pressed("ui_accept"):
		id+=1
		if id==data.size():
			Global.dialogueActive=false
			queue_free()
			return
		_show_dialog()
		
func _show_dialog():
	_name.text = data[id]["title"]
	_dialog.text = data[id]["dialog"]
	_dialog.visible_characters = 0
	
	while _dialog.visible_ratio < 1:
		await get_tree().create_timer(step).timeout
		_dialog.visible_characters+=1
		
	
