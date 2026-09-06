extends CharacterBody2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var collisionopen1: CollisionShape2D = $CollisionOpen1
@onready var collisionopen2: CollisionShape2D = $CollisionOpen2
@onready var collisionclosed: CollisionShape2D = $CollisionClosed1
@onready var occluderopen: LightOccluder2D = $OccluderOpen1
@onready var occludeopen2: LightOccluder2D = $OccluderOpen2
@onready var occluderclosed: LightOccluder2D = $OccluderClosed1
@onready var collisionopen3: CollisionShape2D = $CollisionOpen3
@onready var collisionopen4: CollisionShape2D = $CollisionOpen4
@onready var occluderopen3: LightOccluder2D = $OccluderOpen3
@onready var occluderopen4: LightOccluder2D = $OccluderOpen4


@onready var button = $InteractButton

@export var IsOpen = false
@export var OpenLeft = false
@export var OpenUp = false
@export var spriteTexture: Texture2D

func _ready() -> void:
	if spriteTexture != null:
		sprite.texture = spriteTexture
	
	if IsOpen && !OpenLeft && !OpenUp :
		open1()
		
	if IsOpen && OpenLeft && !OpenUp :
		open2()
		
	if IsOpen && !OpenLeft && OpenUp :
		open3()
		
	if IsOpen && OpenLeft && OpenUp :
		open4()
		
	if !IsOpen && !OpenLeft :
		closed1()
		
	if !IsOpen && OpenLeft :
		closed2()
		
	
	
	
	
	
	
	

func _input(event):
	if event.is_action_pressed("interact") and button.canStartDialog:
		toggle()


func open1():
	sprite.frame = 1
	collisionopen1.disabled = false
	collisionopen2.disabled = true
	collisionopen3.disabled = true
	collisionopen4.disabled = true
	collisionclosed.disabled = true
	
	occluderopen.visible = true
	occludeopen2.visible = false
	occluderopen3.visible = false
	occluderopen4.visible = false
	occluderclosed.visible = false
	button.position = Vector2(-13, -82)
	
	if spriteTexture != null:
		if spriteTexture.resource_path == "res://terrains/Portas/GlassDoor.png":
			occluderopen.visible = false
	
func open3():
	sprite.frame = 4
	collisionopen1.disabled = true
	collisionopen2.disabled = true
	collisionopen3.disabled = false
	collisionopen4.disabled = true
	collisionclosed.disabled = true
	
	occluderopen.visible = false
	occludeopen2.visible = false
	occluderopen3.visible = true
	occluderopen4.visible = false
	occluderclosed.visible = false
	button.position = Vector2(-13, -82)
	
	if spriteTexture != null:
		if spriteTexture.resource_path == "res://terrains/Portas/GlassDoor.png":
			occluderopen3.visible = false
	
func open2():
	sprite.frame = 3
	collisionopen1.disabled = true
	collisionopen2.disabled = false
	collisionopen3.disabled = true
	collisionopen4.disabled = true
	collisionclosed.disabled = true
	
	occluderopen.visible = false
	occludeopen2.visible = true
	occluderopen3.visible = false
	occluderopen4.visible = false
	occluderclosed.visible = false
	button.position = Vector2(12, -61)
	
	if spriteTexture != null:
		if spriteTexture.resource_path == "res://terrains/Portas/GlassDoor.png":
			occludeopen2.visible = false
	
func open4():
	sprite.frame = 5
	collisionopen1.disabled = true
	collisionopen2.disabled = true
	collisionopen3.disabled = true
	collisionopen4.disabled = false
	collisionclosed.disabled = true
	
	occluderopen.visible = false
	occludeopen2.visible = false
	occluderopen3.visible = false
	occluderopen4.visible = true
	occluderclosed.visible = false
	button.position = Vector2(12, -82)
	
	if spriteTexture != null:
		if spriteTexture.resource_path == "res://terrains/Portas/GlassDoor.png":
			occluderopen4.visible = false
	
func closed1():
	sprite.frame = 0
	collisionopen1.disabled = true
	collisionopen2.disabled = true
	collisionopen3.disabled = true
	collisionopen4.disabled = true
	collisionclosed.disabled = false
	
	occluderopen.visible = false
	occludeopen2.visible = false
	occluderopen3.visible = false
	occluderopen4.visible = false
	occluderclosed.visible = true
	button.position = Vector2(0, -61)
	
	if spriteTexture != null:
		if spriteTexture.resource_path == "res://terrains/Portas/GlassDoor.png":
			occluderclosed.visible = false
	
func closed2():
	sprite.frame = 2
	collisionopen1.disabled = true
	collisionopen2.disabled = true
	collisionopen3.disabled = true
	collisionopen4.disabled = true
	collisionclosed.disabled = false
	
	occluderopen.visible = false
	occludeopen2.visible = false
	occluderopen3.visible = false
	occluderopen4.visible = false
	occluderclosed.visible = true
	button.position = Vector2(0, -61)
	
	if spriteTexture != null:
		if spriteTexture.resource_path == "res://terrains/Portas/GlassDoor.png":
			occluderclosed.visible = false

func toggle():
	if sprite.frame == 1:
		closed1()
	elif sprite.frame == 3:
		closed2()
	elif sprite.frame == 4:
		closed1()
	elif sprite.frame == 5:
		closed2()
	elif sprite.frame == 0 && !OpenUp:
		open1()
	elif sprite.frame == 2  && !OpenUp:
		open2()
	elif sprite.frame == 0 && OpenUp:
		open3()
	elif sprite.frame == 2  && OpenUp:
		open4()
