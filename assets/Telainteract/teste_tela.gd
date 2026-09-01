extends Node2D
@onready var interactButton = $InteractButton
@onready var tela: Sprite2D = $CanvasLayer/Tela
@onready var sair: Button = $CanvasLayer/Tela/Sair
@export var imagem: Texture2D
@export var sairbutton: Texture2D


func _ready() -> void:
	tela.texture = imagem
	sair.pressed.connect(sair_pressed)
	sair.icon = sairbutton
	process_mode = Node.PROCESS_MODE_ALWAYS
func _input(event):
	if event.is_action_pressed("interact") and interactButton.canStartDialog:
		toggle()
		
func toggle():
	tela.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
func sair_pressed():
	tela.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	get_tree().paused = false
