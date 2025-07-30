shader_type canvas_item;

// 常规网格设置
uniform vec4 grid_color : source_color = vec4(0.1, 0.1, 0.1, 1.0); // 默认暗网格
uniform float small_grid_thickness = 0.01;
uniform float small_grid_density = 80.0;
uniform float big_grid_thickness = 0.03;
uniform float big_grid_density = 16.0;

// 波纹设置
const int MAX_SHOCKWAVES = 10;
uniform vec2 shockwave_centers[MAX_SHOCKWAVES];
uniform float shockwave_intensities[MAX_SHOCKWAVES];
uniform vec2 shockwave_directions[MAX_SHOCKWAVES];
uniform vec3 shockwave_colors[MAX_SHOCKWAVES]; // 新增：每个shockwave的颜色
uniform float shockwave_radii[MAX_SHOCKWAVES]; // 新增：每个shockwave的范围
uniform int active_shockwaves;

uniform float distortion_strength = 0.1;
uniform float directional_influence = 1.0;
uniform float lighting_strength = 2.0; // 控制照明贡献的强度
uniform float glow_strength = 1.5; // 控制辉光贡献的强度

float grid(vec2 uv, float thickness, float density) {
    vec2 grid_uv = uv * vec2(density);
    vec2 grid_line = step(vec2(thickness), fract(grid_uv));
    return 1.0 - min(grid_line.x, grid_line.y);
}

void fragment() {
    vec2 total_offset = vec2(0.0);
    vec3 total_lighting = vec3(0.0); // 新增：累加照明颜色和强度
    float total_glow = 0.0;

    // 遍历所有活跃的波纹
    for (int i = 0; i < active_shockwaves; i++) {
        vec2 center = shockwave_centers[i];
        float intensity = shockwave_intensities[i];
        vec2 move_direction = shockwave_directions[i];
        vec3 color = shockwave_colors[i];
        float radius = shockwave_radii[i];

        float dist_to_center = distance(UV, center);
        vec2 dir_from_center = normalize(UV - center);

        // 计算基础的径向衰减，使用每个shockwave的radius
        float falloff = 1.0 - smoothstep(0.0, radius, dist_to_center);
        float wave_intensity = intensity * falloff;

        vec2 final_direction = dir_from_center;
        float wave = 0.0;

        if (length(move_direction) < 0.01) {
            // 纯径向波（爆炸）
            wave = sin(dist_to_center * 25.0 - TIME * 5.0) * wave_intensity;
        } else {
            // 方向性波（玩家）
            float dot_product = dot(dir_from_center, -move_direction);
            float forward_weight = smoothstep(-0.2, 0.5, dot_product);
            wave_intensity *= forward_weight;
            float phase_shift = dot_product * 2.5;
            wave = sin(dist_to_center * 25.0 - TIME * 5.0 - phase_shift) * wave_intensity;
        }

        total_offset += final_direction * wave * distortion_strength;
        total_glow += wave_intensity;
        
        vec3 lighting_contrib = color * wave_intensity * lighting_strength;
        total_lighting += lighting_contrib;
    }

    vec2 distorted_uv = UV + total_offset;
    float small_grid_value = grid(distorted_uv, small_grid_thickness, small_grid_density);
    float big_grid_value = grid(distorted_uv, big_grid_thickness, big_grid_density);
    float combined_grid_value = max(small_grid_value, big_grid_value * 1.5);

    // 基础颜色：仅在网格线上
    vec3 base_color = combined_grid_value * grid_color.rgb;

    // 最终颜色：仅在网格线上应用照明（additive方式，以保持网格线亮度并添加颜色tint）
    // 这会使照明仅影响网格线区域，off-line保持黑色
    vec3 final_color = base_color + combined_grid_value * total_lighting;

    // 添加辉光：仅在网格线上基于total_glow增加emission-like效果（WorldEnvironment会glow它）
    final_color += combined_grid_value * grid_color.rgb * total_glow * glow_strength; // 使用参数替换硬编码*1.5

    COLOR = vec4(final_color, 1.0);
}