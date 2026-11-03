shader_type canvas_item;

// Certifique-se de que a textura de ruído está como Seamless no Inspetor
uniform sampler2D noise_texture : repeat_enable;
uniform vec4 fog_color : source_color = vec4(0.8, 0.8, 0.9, 0.6);
uniform vec2 speed = vec2(10.0, 5.0);
uniform float noise_scale = 0.002;

// --- NOVOS UNIFORMS PARA O EFEITO DO PLAYER ---
uniform vec2 player_world_position; // Posição global do jogador (passada via script)
uniform float safe_zone_radius = 0.0; // Raio onde NÃO há névoa nenhuma
uniform float fade_distance = 200.0; // Distância necessária para a névoa voltar a ficar 100% forte

varying vec2 world_position;

void vertex() {
	// Captura a posição real de cada pixel no mundo do jogo
	world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	// 1. Pega o alfa do tile desenhado
	vec4 tile_color = texture(TEXTURE, UV);
	
	// 2. Cria as coordenadas do Noise baseadas na posição global + movimento no tempo
	vec2 moving_coords = (world_position * noise_scale) + (TIME * speed * noise_scale);
	
	// 3. Lê o Noise contínuo do mundo
	vec4 noise_color = texture(noise_texture, moving_coords);
	
	// --- LOGICA DA DISTÂNCIA DO PLAYER ---
	// Calcula a distância em pixels entre este ponto da névoa e o jogador
	float distance_to_player = distance(world_position, player_world_position);
	
	// Cria uma transição suave baseada no raio seguro e na distância de fade
	// smoothstep retorna 0.0 se estiver dentro do safe_zone e vai subindo até 1.0 conforme se afasta
	float player_mask = smoothstep(safe_zone_radius, safe_zone_radius + fade_distance, distance_to_player);
	
	// 4. Junta os três: o Noise, o Alfa do tile e a Máscara do jogador
	float final_alpha = noise_color.r * tile_color.a * player_mask;
	
	COLOR = vec4(fog_color.rgb, final_alpha * fog_color.a);
}
