shader_type canvas_item;
uniform sampler2D noise_texture: repeat_enable,filter_nearest;
// Controla a velocidade do movimento (X e Y)
uniform vec2 velocidade = vec2(0.01, 0.005);

void fragment() {
    // Desloca as coordenadas UV com base no tempo interno do Godot
    vec2 uv_deslocado = UV + (TIME * velocidade);
    
    // COLOR antes da linha abaixo guarda o 'modulate' do seu nó.
    // Multiplicar a textura por COLOR mantém a sua cor personalizada!
    COLOR = texture(TEXTURE, uv_deslocado);
}
