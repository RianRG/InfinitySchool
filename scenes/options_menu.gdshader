shader_type canvas_item;

uniform float blur_amount : hint_range(0.0, 10.0) = 4.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec2 pixel_size = SCREEN_PIXEL_SIZE * blur_amount;
	vec4 sum = vec4(0.0);

	sum += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(-4.0, -4.0) * pixel_size) * 0.05;
	sum += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(-3.0, -3.0) * pixel_size) * 0.09;
	sum += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(-2.0, -2.0) * pixel_size) * 0.12;
	sum += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(-1.0, -1.0) * pixel_size) * 0.15;
	sum += texture(SCREEN_TEXTURE, SCREEN_UV) * 0.16;
	sum += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(1.0, 1.0) * pixel_size) * 0.15;
	sum += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(2.0, 2.0) * pixel_size) * 0.12;
	sum += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(3.0, 3.0) * pixel_size) * 0.09;
	sum += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(4.0, 4.0) * pixel_size) * 0.05;

	COLOR = mix(sum, vec4(0.0, 0.0, 0.0, 1.0), 0.8); // 30% de escurecimento
}