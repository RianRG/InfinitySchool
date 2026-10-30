shader_type canvas_item;

// Certifique-se de que a textura de ruído está como Seamless no Inspetor
uniform sampler2D noise_texture : repeat_enable; 
uniform vec4 fog_color : source_color = vec4(0.5, 0.5, 0.6, 1.0);
uniform vec2 speed = vec2(10.0, 5.0); // Velocidade maior porque a escala mudou
uniform float noise_scale = 0.005;   // Controla o "zoom" da névoa no mapa

varying vec2 world_position;

void vertex() {
    // Captura a posição real de cada pixel no mundo do jogo
    world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
    // 1. Pega o alfa do tile desenhado (continua local para cada tile)
    vec4 tile_color = texture(TEXTURE, UV);
    
    // 2. Cria as coordenadas do Noise baseadas na posição global + movimento no tempo
    vec2 moving_coords = (world_position * noise_scale) + (TIME * speed * noise_scale);
    
    // 3. Lê o Noise contínuo do mundo
    vec4 noise_color = texture(noise_texture, moving_coords);
    
    // 4. Junta os dois: o Noise contínuo só aparece onde o tile tem Alfa
    float final_alpha = noise_color.r * tile_color.a;
    
    COLOR = vec4(fog_color.rgb, final_alpha * fog_color.a);
}
