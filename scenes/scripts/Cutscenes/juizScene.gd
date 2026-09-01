extends Node2D
@onready var boss: CharacterBody2D = $Juiz
@onready var camera: Camera2D = $Camera2D
@onready var player = $player
@onready var playerPhantom: PhantomCamera2D = $PhantomCamera2D
@onready var playerPhantom2: PhantomCamera2D = $PhantomCamera2D2
@onready var bossAnimationPhantom: PhantomCamera2D = $bossAnimationPhantom
@onready var bossFightPhantom: PhantomCamera2D = $bossFightPhantom
@onready var bigDoor: BigDoor = $bigdoor
@onready var luz2 = $PointLight2D3
@onready var luz3 = $PointLight2D4
@onready var branco = $Sprite2D2
@onready var theme: AudioStreamPlayer = $Theme
@onready var boss_scream: AudioStreamPlayer = $BossScream
@onready var entrada: AudioStreamPlayer = $Entrada
@onready var judge_title: AnimatedSprite2D = $JudgeTitle
@onready var escMenu: Control = $CanvasLayer/EscMenu

const creditsScene: PackedScene = preload("res://scenes/credits.tscn")

var cutscenePlayed:=false
func _ready() -> void:
	
	playerPhantom.set_tween_transition(5)
	bossAnimationPhantom.set_tween_transition(5)
	bossFightPhantom.set_tween_transition(5)
	
	bossFightPhantom.set_tween_duration(1)
	playerPhantom.set_tween_duration(2)
	bossAnimationPhantom.set_tween_duration(3)
	
var _credits_shown := false

func _process(delta: float) -> void:
	if boss.isDead and not _credits_shown:
		_credits_shown = true
		await get_tree().create_timer(6).timeout
		var credits = creditsScene.instantiate()
		var layer = CanvasLayer.new()
		layer.layer = 20
		get_tree().current_scene.add_child(layer)
		layer.add_child(credits)
		theme.stop()

func startCutscene(layer):
	await get_tree().create_timer(.4).timeout
	
	playerPhantom.priority=0
	bossAnimationPhantom.priority=10
	await get_tree().create_timer(1).timeout
	camera.screenShake(7,5)
	boss_scream.play()
	judge_title.play()
	await get_tree().create_timer(1.5).timeout
	endCutscene(layer)
	
func endCutscene(layer):
	bossFightPhantom.priority=10
	bossAnimationPhantom.priority=0
	boss.hammer.startTimer()
	await get_tree().create_timer(1).timeout
	player.isRunning=true
	player.canDash=true
	player.set_physics_process(true)
	player.set_process_input(true)
	escMenu.set_process(true) 
	boss.set_physics_process(true)
	boss.finitestate.change_state("follow")
	if is_instance_valid(layer):
		layer.queue_free()
	

func switchToBossFightCamera():
	bossFightPhantom.priority=10
	playerPhantom2.priority=0
	playerPhantom.priority=0

func _on_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("character") and !cutscenePlayed:
		cutscenePlayed=true
		bigDoor.block()
		player.force_idle()
		player.set_physics_process(false)
		player.set_process_input(false)
		escMenu.set_process(false)   
		boss.set_physics_process(false)
		player.global_position = Vector2(2944,-832)
		
		switchToBossFightCamera()
		var layer = CanvasLayer.new()
		layer.layer = 20 
	
		get_tree().root.add_child(layer)
	
		var rect = ColorRect.new()
		rect.color = Color(1, 1, 1, 0) 
	
		rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	
		layer.add_child(rect)
	
		var tween = create_tween()
		tween.tween_property(rect, "color", Color(1.0, 1.0, 1.0, 1.0), 0.5)
		entrada.play()
		await get_tree().create_timer(1.5).timeout
		var tween2 = create_tween()
		theme.play()
		tween2.tween_property(rect, "color", Color(1,1,1,0), 1)
		tween2.tween_property(luz2 ,"energy" ,0.0,1)
		tween2.tween_property(luz3 ,"energy" ,0.0,1)
		
		startCutscene(layer)


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("character") and !cutscenePlayed:
		playerPhantom2.priority=10
		playerPhantom.priority=0

func _on_area_2d_2_body_exited(body: Node2D) -> void:
	if body.is_in_group("character") and !cutscenePlayed:
		playerPhantom2.priority=0
		playerPhantom.priority=9
