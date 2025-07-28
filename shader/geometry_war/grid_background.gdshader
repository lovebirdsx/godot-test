shader_type canvas_item;

uniform vec4 grid_color = vec4(0.3, 0.8, 1.0, 1.0);
uniform float grid_thickness = 0.02;
uniform float grid_density = 20.0;

uniform vec2 shockwave_center = vec2(0.5, 0.5);
uniform float shockwave_intensity = 0.0;

uniform float shockwave_radius = 0.4;
uniform float distortion_strength = 0.1;

float grid(vec2 uv, float thickness, float density) {
	vec2 grid_uv = uv * vec2(density);
	vec2 grid_line = step(vec2(thickness), fract(grid_uv));
	return 1.0 - min(grid_line.x, grid_line.y);
}

void fragment() {
	float dist = distance(UV, shockwave_center);
	float falloff = 1.0 - smoothstep(0.0, shockwave_radius, dist);
	float total_intensity = shockwave_intensity * falloff;
	vec2 direction = normalize(UV - shockwave_center);
	float wave = sin(dist * 25.0 - TIME * 5.0) * total_intensity;
	vec2 offset = direction * wave * distortion_strength;

	vec2 distorted_uv = UV + offset;
	float grid_value = grid(distorted_uv, grid_thickness, grid_density);
	vec3 final_color = grid_value * grid_color.rgb;

	final_color += grid_color.rgb * total_intensity * 0.7;
	COLOR = vec4(final_color, 1.0);
}
