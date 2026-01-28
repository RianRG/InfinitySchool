extends Node2D
class_name Level
var dialogScreen: PackedScene = preload("res://dialogue.tscn")
var dialogData: Dictionary = {
	0: {
		"title": "O Grilo",
		"dialog": "Sou eu, sou eu, sou eu"
	},
	1: {
		"title": "O Grilo",
		"dialog": "Quem vai mudar o mundo"
	},
	2: {
		"title": "O Grilo",
		"dialog": "Sou eu, sou eu, sou eu"
	}
}

@export_category("Objects")
@onready var hud: CanvasLayer = $HUD

func _process(delta: float):
	if Input.is_action_just_pressed("ui_select"):
		var newDialog: DialogueScreen = dialogScreen.instantiate()
		newDialog.data = dialogData
		hud.add_child(newDialog)
