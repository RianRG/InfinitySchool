extends Node2D
var canStartDialog: bool = false
@onready var buttonSprite: Node2D = $buttonSprite


func appear():
	buttonSprite.appear()
	pass
func disappear():
	buttonSprite.disappear()
	pass
