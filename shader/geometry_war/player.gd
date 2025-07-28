extends Sprite2D

@export var speed: float = 300

@onready var background_material: ShaderMaterial = $"../Background".material

var shockwave_intensity: float = 0.0

func _process(delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += direction * speed * delta

	if background_material:
		var viewport_size = get_viewport_rect().size
		var player_uv = global_position / viewport_size
		background_material.set_shader_parameter("shockwave_center", player_uv)

	if direction.length() > 0:
		shockwave_intensity = move_toward(shockwave_intensity, 1.0, delta * 2.0)
	else:
		shockwave_intensity = move_toward(shockwave_intensity, 0.0, delta * 2.0)

	background_material.set_shader_parameter("shockwave_intensity", shockwave_intensity)
