extends Node2D
class_name Door
@onready var collisionClosed: CollisionShape2D = $CollisionClosed
@onready var collisionOpen: CollisionShape2D = $CollisionOpen

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var interactButton = $InteractButton


@export var isOpen := false
@export var PathImage :="res://terrains/Portas/porta1.png"
@onready var sprite_2d: Sprite2D = $Sprite2D


func _input(event):
	if event.is_action_pressed("interact") and interactButton.canStartDialog:
		toggle()

func _ready():
	if isOpen:
		animation.play("open")
		collisionClosed.disabled = !collisionClosed.disabled
		collisionOpen.disabled=!collisionOpen.disable
		
	sprite_2d.texture = PathImage

func toggle():
	if not interactButton.canStartDialog:
		return

	isOpen = !isOpen

	if isOpen:
		animation.play("open")
		collisionClosed.disabled = !collisionClosed.disabled
		collisionOpen.disabled=!collisionOpen.disabled
	else:
		animation.play("closed")
		collisionClosed.disabled = !collisionClosed.disabled
		collisionOpen.disabled=!collisionOpen.disabled
