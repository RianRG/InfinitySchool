extends Area2D
@onready var phantomcamera: PhantomCamera2D = $"../PhantomCamera2D"
@onready var bounds2 :NodePath = "cameraBounds/Bounds2"
@onready var bigdoor: BigDoor = $"../bigdoor"
@onready var beentogogled = false


func _on_body_entered(body: Node2D) -> void:
	if body is Player && beentogogled == false:
		bigdoor.toggle()
		beentogogled = true
		
		
