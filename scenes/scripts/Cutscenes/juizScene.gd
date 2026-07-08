extends Node2D
@onready var boss: CharacterBody2D = $Juiz
@onready var camera: Camera2D = $Camera2D
@onready var player = $player
@onready var playerPhantom: PhantomCamera2D = $PhantomCamera2D
@onready var bossAnimationPhantom: PhantomCamera2D = $bossAnimationPhantom
@onready var bossFightPhantom: PhantomCamera2D = $bossFightPhantom
@onready var bigDoor: BigDoor = $bigdoor
var cutscenePlayed:=false
func _ready() -> void:
	playerPhantom.set_tween_transition(5)
	bossAnimationPhantom.set_tween_transition(5)
	bossFightPhantom.set_tween_transition(5)
	
	bossFightPhantom.set_tween_duration(1)
	playerPhantom.set_tween_duration(3)
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
	await get_tree().create_timer(2).timeout
	camera.screenShake(7,5 )
	await get_tree().create_timer(5).timeout
	endCutscene()
	# 6. Shake da câmera
	
func endCutscene():
	player.set_physics_process(true)
	player.set_process_input(true)
	boss.set_physics_process(true)
	
	bossFightPhantom.priority=10
	bossAnimationPhantom.priority=0
	

func switchToBossFightCamera():
	
	bossFightPhantom.priority=10
	playerPhantom.priority=0
func _on_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("character") and !cutscenePlayed:
		bigDoor.block()
		player._change_state(player.PlayerState.IDLE)
		
		player.set_physics_process(false)
		player.set_process_input(false)
		boss.set_physics_process(false)
		
		switchToBossFightCamera()
		await get_tree().create_timer(2).timeout
		startCutscene()
