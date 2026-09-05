extends CharacterBody2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var collisionopen1: CollisionShape2D = $CollisionOpen1
@onready var collisionopen2: CollisionShape2D = $CollisionOpen2
@onready var collisionclosed: CollisionShape2D = $CollisionClosed1
@onready var occluderopen: LightOccluder2D = $OccluderOpen1
@onready var occludeopen2: LightOccluder2D = $OccluderOpen2
@onready var occluderclosed: LightOccluder2D = $OccluderClosed1

@onready var button = $InteractButton

@export var IsOpen = false
@export var OpenLeft = false
@export var spriteTexture: Texture2D

func _ready() -> void:
	if spriteTexture != null:
		sprite.texture = spriteTexture
	
	if IsOpen && !OpenLeft :
		open1()
		button.position = Vector2(-8, -61)
	if IsOpen && OpenLeft :
		open2()
		button.position = Vector2(8, -61)
	if !IsOpen && !OpenLeft :
		closed1()
		button.position = Vector2(-8, -61)
	if !IsOpen && OpenLeft :
		closed2()
		button.position = Vector2(8, -61)

func _input(event):
	if event.is_action_pressed("interact") and button.canStartDialog:
		toggle()


func open1():
	sprite.frame = 1
	collisionopen1.disabled = false
	collisionopen2.disabled = true
	collisionclosed.disabled = true
	
	occluderopen.visible = true
	occludeopen2.visible = false
	occluderclosed.visible = false
	
func open2():
	sprite.frame = 3
	collisionopen1.disabled = true
	collisionopen2.disabled = false
	collisionclosed.disabled = true
	
	occluderopen.visible = false
	occludeopen2.visible = true
	occluderclosed.visible = false
	
func closed1():
	sprite.frame = 0
	collisionopen1.disabled = true
	collisionopen2.disabled = true
	collisionclosed.disabled = false
	
	occluderopen.visible = false
	occludeopen2.visible = false
	occluderclosed.visible = true
	
func closed2():
	sprite.frame = 2
	collisionopen1.disabled = true
	collisionopen2.disabled = true
	collisionclosed.disabled = false
	
	occluderopen.visible = false
	occludeopen2.visible = false
	occluderclosed.visible = true

func toggle():
	if sprite.frame == 1:
		closed1()
	elif sprite.frame == 3:
		closed2()
	elif sprite.frame == 0:
		open1()
	elif sprite.frame == 2:
		open2()
