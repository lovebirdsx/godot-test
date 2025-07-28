shader_type canvas_item;

// 常规网格设置
uniform vec4 grid_color : source_color = vec4(0.3, 0.8, 1.0, 1.0);
uniform float grid_thickness = 0.02;
uniform float grid_density = 20.0;

// 波纹设置
const int MAX_SHOCKWAVES = 10; // 定义着色器能同时处理的最大波纹数量
uniform vec2 shockwave_centers[MAX_SHOCKWAVES];
uniform float shockwave_intensities[MAX_SHOCKWAVES];
uniform vec2 shockwave_directions[MAX_SHOCKWAVES]; // 每个波纹的方向
uniform int active_shockwaves; // 当前活跃的波纹数量

uniform float shockwave_radius = 0.4;
uniform float distortion_strength = 0.1;
uniform float directional_influence = 1.0; // 在新逻辑中不再直接使用，但保留

float grid(vec2 uv, float thickness, float density) {
	vec2 grid_uv = uv * vec2(density);
	vec2 grid_line = step(vec2(thickness), fract(grid_uv));
	return 1.0 - min(grid_line.x, grid_line.y);
}

void fragment() {
	vec2 total_offset = vec2(0.0);
	float total_glow = 0.0;

	// 遍历所有活跃的波纹并累加它们的效果
	for (int i = 0; i < active_shockwaves; i++) {
		vec2 center = shockwave_centers[i];
		float intensity = shockwave_intensities[i];
		vec2 move_direction = shockwave_directions[i];

		float dist_to_center = distance(UV, center);
		vec2 dir_from_center = normalize(UV - center);

		// 计算基础的径向衰减
		float falloff = 1.0 - smoothstep(0.0, shockwave_radius, dist_to_center);
		float wave_intensity = intensity * falloff;
		
		vec2 final_direction = dir_from_center;
		float wave = 0.0;

		// 检查移动方向的长度，如果很小，则视为无方向的爆炸波（例如子弹命中）
		if (length(move_direction) < 0.01) {
			// 纯径向波
			wave = sin(dist_to_center * 25.0 - TIME * 5.0) * wave_intensity;
		} else {
			// 具有方向性的移动波（玩家）
			// 1. 使用点积判断像素相对于移动方向的位置
			//    - dot_product > 0: 在前方
			//    - dot_product < 0: 在后方
			float dot_product = dot(dir_from_center, -move_direction);

			// 2. 创建一个前向权重，让效果在后方平滑消失
			//    - 这将消除移动时后方的折痕
			float forward_weight = smoothstep(-0.2, 0.5, dot_product);
			wave_intensity *= forward_weight;

			// 3. 根据点积进行相位偏移，制造V形"撑开"效果
			//    - 这会让前方的波峰被向前推
			float phase_shift = dot_product * 2.5;
			wave = sin(dist_to_center * 25.0 - TIME * 5.0 - phase_shift) * wave_intensity;
		}
		
		total_offset += final_direction * wave * distortion_strength;
		total_glow += wave_intensity;
	}

	vec2 distorted_uv = UV + total_offset;
	float grid_value = grid(distorted_uv, grid_thickness, grid_density);
	vec3 final_color = grid_value * grid_color.rgb;

	// 添加辉光效果
	// final_color += grid_color.rgb * total_glow * 0.7;
	
	COLOR = vec4(final_color, 1.0);
}