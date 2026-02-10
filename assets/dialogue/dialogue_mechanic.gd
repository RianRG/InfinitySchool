extends Node2D
class_name DialogueMechanic
@onready var interactButton: Node2D = $InteractButton


@export var spriteTexture: Texture2D

var dialogueScene = preload("res://assets/dialogue/dialogueScene.tscn")
var canStartDialog: bool = false
@export var dialogData: Dictionary = {
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
		"dialog": "Sou eu, sou eu, sou eu, que quando falo fico surdo. Eu sei, eu sei, eu seeeei"
	}
}

@export_category("Objects")
@onready var hud: CanvasLayer = $HUD
var newDialog =null 
func _process(delta: float):
	if Input.is_action_just_pressed("interact") and interactButton.canStartDialog and newDialog==null:
		newDialog = dialogueScene.instantiate()
		if spriteTexture: 
			newDialog.get_node("sprite").texture = spriteTexture

		print(newDialog)
		interactButton.disappear()
		hud.add_child(newDialog)
		newDialog.start(dialogData)
