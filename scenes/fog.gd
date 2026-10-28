extends Sprite2D

# Velocidade do movimento horizontal e vertical
@export var movimento_velocidade: Vector2 = Vector2(10.0, 5.0)

# Velocidade com que o ruído muda de forma (morfose)
@export var metamorfose_velocidade: float = 0.5

var noise_texture: NoiseTexture2D

func _ready() -> void:
	# Pega a textura atual do nó
	if texture is NoiseTexture2D:
		noise_texture = texture
	else:
		push_error("A textura precisa ser uma NoiseTexture2D!")

func _process(delta: float) -> void:
	if not noise_texture:
		return
		
	# 1. FAZ SE MEXER: Desloca o offset do ruído no plano X e Y
	# Se usar Sprite2D com Region, você pode preferir mover a 'region_rect.position'
	noise_texture.noise.offset.x += movimento_velocidade.x * delta
	noise_texture.noise.offset.y += movimento_velocidade.y * delta
	
	# 2. FAZ MUDAR AOS POUCOS: Move o ruído no eixo Z (morfose 3D projetada no 2D)
	noise_texture.noise.offset.z += metamorfose_velocidade * delta
