extends Node
class_name ShockwaveManager

const MAX_SHOCKWAVES = 10 # 必须与着色器中的 MAX_SHOCKWAVES 保持一致

var shockwaves = []
var background_material: ShaderMaterial

func _ready() -> void:
	await get_tree().process_frame
	var main_scene = get_tree().current_scene
	if main_scene.has_node("Background"):
		background_material = main_scene.get_node("Background").material
	else:
		push_error("ShockwaveManager could not find a Node named 'Background' with a material.")

func _process(delta: float) -> void:
	if not is_instance_valid(background_material):
		return

	var centers = []
	var intensities = []
	var directions = []
	
	var i = 0
	while i < shockwaves.size():
		var sw = shockwaves[i]
		
		# 对非玩家的波纹（例如爆炸）应用通用衰减逻辑
		if not sw.has("id"):
			sw.intensity = move_toward(sw.intensity, 0.0, sw.fade_rate * delta)
		
		if sw.intensity <= 0.0:
			shockwaves.remove_at(i)
		else:
			centers.push_back(sw.position)
			intensities.push_back(sw.intensity)
			directions.push_back(sw.direction)
			i += 1
	
	if not centers.is_empty():
		background_material.set_shader_parameter("active_shockwaves", centers.size())
		background_material.set_shader_parameter("shockwave_centers", centers)
		background_material.set_shader_parameter("shockwave_intensities", intensities)
		background_material.set_shader_parameter("shockwave_directions", directions)
	else:
		background_material.set_shader_parameter("active_shockwaves", 0)

# 公共接口：用于在指定位置创建一个波纹（用于炮弹等瞬时效果）
func create_shockwave(pos: Vector2, initial_intensity: float, move_direction: Vector2 = Vector2.ZERO, fade_rate: float = 2.0):
	if shockwaves.size() >= MAX_SHOCKWAVES:
		return

	var viewport_size = get_viewport().get_visible_rect().size
	var uv_pos = pos / viewport_size

	var new_shockwave = {
		"position": uv_pos,
		"intensity": initial_intensity,
		"direction": move_direction.normalized(),
		"fade_rate": fade_rate
	}
	shockwaves.append(new_shockwave)

# 用于玩家移动时持续更新的特殊波纹
func update_or_create_player_shockwave(id: int, pos: Vector2, target_intensity: float, move_direction: Vector2, delta: float):
	var found_wave = null
	for sw in shockwaves:
		if sw.get("id") == id:
			found_wave = sw
			break
			
	if found_wave == null:
		# 如果没找到，并且玩家正在移动，则创建一个新的
		if target_intensity > 0.0 and shockwaves.size() < MAX_SHOCKWAVES:
			var viewport_size = get_viewport().get_visible_rect().size
			var new_shockwave = {
				"id": id,
				"position": pos / viewport_size,
				"intensity": 0.0, # 初始强度为0
				"direction": move_direction.normalized(),
			}
			shockwaves.append(new_shockwave)
			found_wave = new_shockwave
	
	# 对找到的或新创建的玩家波纹进行更新
	if found_wave != null:
		var viewport_size = get_viewport().get_visible_rect().size
		found_wave.position = pos / viewport_size
		if move_direction.length() > 0.01:
			found_wave.direction = move_direction.normalized()
		# 关键改动：将强度更新的逻辑移到这里，由目标强度驱动
		found_wave.intensity = move_toward(found_wave.intensity, target_intensity, 2.0 * delta)
