shader_type canvas_item;

// Ponto de entrada do player (coordenadas UV: de 0.0 a 1.0)
uniform vec2 player_entry_point = vec2(0.5, 0.5);
// Progresso da revelação (de 0.0 a 1.5)
uniform float reveal_progress : hint_range(0.0, 1.5) = 0.0;
uniform float smoothness = 0.1;

void fragment() {
	// Pega a cor preta definida no ColorRect
	vec4 current_color = COLOR;
	
	// Calcula a distância usando a UV nativa do ColorRect
	float dist = distance(UV, player_entry_point);
	float alpha = smoothstep(reveal_progress - smoothness, reveal_progress, dist);
	
	COLOR = vec4(current_color.rgb, current_color.a * alpha);
}