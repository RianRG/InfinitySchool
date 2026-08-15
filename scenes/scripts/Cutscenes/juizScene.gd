extends Node2D
@onready var boss: CharacterBody2D = $Juiz
@onready var camera: Camera2D = $Camera2D
@onready var player = $player
@onready var playerPhantom: PhantomCamera2D = $PhantomCamera2D
@onready var bossAnimationPhantom: PhantomCamera2D = $bossAnimationPhantom
@onready var bossFightPhantom: PhantomCamera2D = $bossFightPhantom
@onready var bigDoor: BigDoor = $bigdoor
@onready var luz2 = $PointLight2D3
@onready var luz3 = $PointLight2D4
@onready var branco = $Sprite2D2

var cutscenePlayed:=false
func _ready() -> void:
	playerPhantom.set_tween_transition(5)
	bossAnimationPhantom.set_tween_transition(5)
	bossFightPhantom.set_tween_transition(5)
	
	bossFightPhantom.set_tween_duration(1)
	playerPhantom.set_tween_duration(2)
	bossAnimationPhantom.set_tween_duration(3)

func _process(delta: float) -> void:
	pass
	
func startCutscene():
	cutscenePlayed=true
	await get_tree().create_timer(.4).timeout
	#playerPhantom.set_tween_ease(1)
	#bossAnimationPhantom.set_tween_ease(1)
	
	
	# 2. Transfere a câmera para a cena (ou faz ela seguir um ponto)
	playerPhantom.priority=0
	bossAnimationPhantom.priority=10
	await get_tree().create_timer(1).timeout
	camera.screenShake(7,5)
	await get_tree().create_timer(3).timeout
	endCutscene()
	# 6. Shake da câmera
	
func endCutscene():
	player.set_physics_process(true)
	player.set_process_input(true)
	boss.set_physics_process(true)
	bigDoor.block()
	
	bossFightPhantom.priority=10
	bossAnimationPhantom.priority=0
	boss.finitestate.change_state("follow")
	boss.hammer.startTimer()
	

func switchToBossFightCamera():
	
	bossFightPhantom.priority=10
	playerPhantom.priority=0
func _on_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("character") and !cutscenePlayed:
		
		await get_tree().create_timer(.6).timeout
		player.force_idle()
		player.set_physics_process(false)
		player.set_process_input(false)
		boss.set_physics_process(false)
		
		
		
		
		switchToBossFightCamera()
		var layer = CanvasLayer.new()
		layer.layer = 20 
	
		get_tree().root.add_child(layer)
	
		# cria retângulo branco fullscreen
		var rect = ColorRect.new()
		rect.color = Color(1, 1, 1, 0) 
	
		rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	
		layer.add_child(rect)
	
		var tween = create_tween()
		tween.tween_property(rect, "color", Color(1,1,1,1), 0.5)
		await get_tree().create_timer(1.5).timeout
		var tween2 = create_tween()
		tween2.tween_property(rect, "color", Color(1,1,1,0), 1)
		tween2.tween_property(luz2 ,"energy" ,0.0,1)
		tween2.tween_property(luz3 ,"energy" ,0.0,1)
		startCutscene()
		
		
