extends Node2D
class_name Door
@onready var collisionClosed: CollisionShape2D = $CollisionClosed
@onready var collisionOpen: CollisionShape2D = $CollisionOpen

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var interactButton = $InteractButton


@export var isOpen := false
@onready var sprite: Sprite2D = $Sprite2D
@export var spriteTexture: Texture2D

@export var ceilling: TileMapLayer


func _input(event):
	if event.is_action_pressed("interact") and interactButton.canStartDialog:
		toggle()
		

func _ready():
		
	if spriteTexture:
		sprite.texture = spriteTexture
		
	if isOpen:
		animation.play("open")
		collisionClosed.disabled = !collisionClosed.disabled
		collisionOpen.disabled=!collisionOpen.disabled
		$LightOccluder2D.visible = true
		$LightOccluder2D2.visible = false
	else: 
		$LightOccluder2D.visible = false
		$LightOccluder2D2.visible = true

func toggle():
	if not interactButton.canStartDialog:
		return

	isOpen = !isOpen

	if isOpen:
		animation.play("open")
		collisionClosed.disabled = !collisionClosed.disabled
		collisionOpen.disabled=!collisionOpen.disabled
		$LightOccluder2D.visible = true
		$LightOccluder2D2.visible = false
		var tween = create_tween()
		tween.tween_property(ceilling, "modulate:a", 0.0, 0.5)
	else:
		animation.play("closed")
		collisionClosed.disabled = !collisionClosed.disabled
		collisionOpen.disabled=!collisionOpen.disabled
		$LightOccluder2D.visible = false
		$LightOccluder2D2.visible = true
		var tween = create_tween()
		tween.tween_property(ceilling, "modulate:a", 1, 0.5)
