extends Node2D
@onready var boss: CharacterBody2D = $Juiz
@onready var camera: Camera2D = $Camera2D
@onready var player: Player = $player
var cutscenePlayed:=false
@onready var playerPhantom: PhantomCamera2D = $PhantomCamera2D
@onready var bossPhantom: PhantomCamera2D = $bossCamera

#func _ready() -> void:
	#startCutscene()

func _process(delta: float) -> void:
	pass
	
func startCutscene():
	player.set_physics_process(false)
	player.set_process_input(false)
	boss.set_physics_process(false)
	await get_tree().create_timer(.4).timeout
	#playerPhantom.set_tween_ease(1)
	#bossPhantom.set_tween_ease(1)
	playerPhantom.set_tween_transition(5)
	bossPhantom.set_tween_transition(5)
	
	playerPhantom.set_tween_duration(3)
	bossPhantom.set_tween_duration(3)
	
	# 2. Transfere a câmera para a cena (ou faz ela seguir um ponto)
	playerPhantom.priority=0
	bossPhantom.priority=10
	await get_tree().create_timer(2).timeout
	camera.screenShake(7,5 )
	await get_tree().create_timer(5).timeout
	endCutscene()
	# 6. Shake da câmera
	
func endCutscene():
	player.set_physics_process(true)
	player.set_process_input(true)
	boss.set_physics_process(true)
	playerPhantom.priority=10
	bossPhantom.priority=0
