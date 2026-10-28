extends TileMapLayer

func _ready():
	var usado = get_used_rect()
	if usado.size == Vector2i.ZERO: return
	
	# 1. Pega a textura original do seu Tileset para podermos copiar os desenhos dela
	var tile_set_textura = tile_set.get_source(0).texture.get_image()
	
	# 2. Cria a imagem final na memória (vazia e totalmente transparente)
	var imagem_final = Image.create(usado.size.x * 2, usado.size.y * 2, false, Image.FORMAT_RGBA8)
	
	# 3. Percorre apenas as células que você REALMENTE pintou no mapa
	for cell in get_used_cells():
		# Descobre qual tile do atlas está sendo usado nessa célula
		var coords_atlas = get_cell_atlas_coords(cell)
		
		# Calcula a posição de onde esse tile está na imagem do Tileset original (escala 2x2)
		var src_x = coords_atlas.x * 2
		var src_y = coords_atlas.y * 2
		var area_src = Rect2i(src_x, src_y, 2, 2)
		
		# Calcula a posição correta de onde colar esse tile na imagem final da fase
		var dest_x = (cell.x - usado.position.x) * 2
		var dest_y = (cell.y - usado.position.y) * 2
		var dest_pos = Vector2i(dest_x, dest_y)
		
		# Copia o desenho exato do tile (com transparências e formatos) para a imagem final
		imagem_final.blit_rect(tile_set_textura, area_src, dest_pos)

	# 4. Transforma a imagem gerada em um Sprite único de alta performance
	var textura = ImageTexture.create_from_image(imagem_final)
	var sprite_sombra = Sprite2D.new()
	sprite_sombra.texture = textura
	sprite_sombra.centered = false
	
	# Posiciona o sprite exatamente sobre o mapa
	sprite_sombra.global_position = map_to_local(usado.position) - Vector2(1, 1) 
	
	# Aplica o modo Multiply
	var mat = CanvasItemMaterial.new()
	mat.blend_mode = CanvasItemMaterial.BLEND_MODE_MUL
	sprite_sombra.material = mat
	
	# Adiciona à cena e deleta o TileMap original que causava o lag
	get_parent().call_deferred("add_child", sprite_sombra)
	queue_free()
