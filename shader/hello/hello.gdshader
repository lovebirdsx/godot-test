shader_type canvas_item;

uniform vec4 base_color = vec4(0.2, 0.0, 0.4, 1.0);
uniform float scroll_speed = 1.0;
uniform float noise_scale = 5.0;

void fragment() {
	vec2 scrolling_uv = UV;
	scrolling_uv.x += TIME * scroll_speed;
	scrolling_uv.y += TIME * scroll_speed * 0.7;

	float noise = (sin(scrolling_uv.x * noise_scale) + sin(scrolling_uv.y * noise_scale)) * 0.5;
	vec3 final_color = base_color.rgb * vec3(noise, noise * 0.5, noise * 0.8);

	COLOR = vec4(final_color, 1.0);
}
