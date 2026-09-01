shader_type canvas_item;

uniform float wave_strength = 0.005;
uniform float wave_speed = 5;
uniform float wave_frequency = 30.0;

void fragment() {
    vec2 uv = UV;

    // Movimento horizontal da água
    uv.x += sin(uv.y * wave_frequency + TIME * wave_speed) * wave_strength;

    COLOR = texture(TEXTURE, uv) * COLOR;
}