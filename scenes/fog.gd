extends TileMapLayer

@export var player: Node2D

func _process(_delta: float) -> void:
	if player and material:
		# Envia a posição global do jogador
		material.set_shader_parameter("player_world_position", player.global_position)
		# Envia a posição global DESTE TileMapLayer
		material.set_shader_parameter("tilemap_global_position", global_position)
	elif not player:
		print("O nó Player não foi atribuído no Inspetor ou sumiu da cena")
