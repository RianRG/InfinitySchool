@tool # Faz o script rodar dentro do editor do Godot
extends Area2D

@onready var color_rect: ColorRect = $"../ColorRect"
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var was_revealed: bool = false
func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	color_rect = $"../ColorRect"

func _process(_delta: float) -> void :
	# Se estivermos editando no Godot, atualiza o shape de colisão para casar com o ColorRect
	if Engine.is_editor_hint():
		if color_rect and collision_shape and collision_shape.shape is RectangleShape2D:
			var rect_size = color_rect.size
			# Ajusta o tamanho do retângulo de colisão
			collision_shape.shape.size = rect_size
			# Centraliza a colisão no meio do ColorRect
			collision_shape.position = rect_size / 2
			# Garante que o ColorRect comece no ponto 0,0 local
			color_rect.position = Vector2.ZERO

func _on_body_entered(body: Node2D) -> void :
	# Ignora se estiver rodando dentro do editor
	if Engine.is_editor_hint(): return
	
	if body.is_in_group("character") and not was_revealed:
		was_revealed = true
		reveal_room(body.global_position)


func reveal_room(player_global_pos: Vector2) -> void :
	# Como o ColorRect cresce a partir do topo-esquerdo (0,0), pegamos a posição local direta
	var local_pos = to_local(player_global_pos) - color_rect.position
	var rect_size = color_rect.size
	
	# Transforma os pixels locais em coordenadas UV (0.0 a 1.0)
	var uv_pos = local_pos / rect_size
	
	var shader_material = color_rect.material as ShaderMaterial
	if shader_material:
		shader_material.set_shader_parameter("player_entry_point", uv_pos)
		
		var tween = create_tween()
		tween.tween_property(shader_material, "shader_parameter/reveal_progress", 1.5, 1.2)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_OUT)
		
		await tween.finished
		queue_free()
