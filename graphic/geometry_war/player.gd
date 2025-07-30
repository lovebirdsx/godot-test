extends Node2D

@export var speed: float = 300
@export var rotation_speed: float = 20
@export var shockwave_radius: float = 0.3
@export var shockwave_color: Color = Color.WHITE

@onready var shockwave_manager: ShockwaveManager = get_node("/root/GeometryWar/ShockwaveManager")
var bullet_scene = preload("res://geometry_war/bullet.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire"):
		var bullet_instance = bullet_scene.instantiate()
		bullet_instance.global_position = global_position
		bullet_instance.direction = Vector2.RIGHT.rotated(rotation) 
		get_parent().add_child(bullet_instance)
	elif event is InputEventMouseButton and event.pressed:
		var mouse_position = get_global_mouse_position()
		var direction = (mouse_position - global_position).normalized()
		var bullet_instance = bullet_scene.instantiate()
		bullet_instance.global_position = global_position
		bullet_instance.direction = direction
		get_parent().add_child(bullet_instance)

func _process(delta: float) -> void:
	var move_dir := Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	position += move_dir.normalized() * speed * delta
	
	if move_dir.length() > 0.1:
		var target_angle: float = move_dir.angle()
		var current_angle: float = rotation
		rotation = lerp_angle(current_angle, target_angle, rotation_speed * delta)
	
	var target_intensity = 0.5 if move_dir.length() > 0 else 0.0
	shockwave_manager.update_or_create_player_shockwave(
		get_instance_id(),
		global_position,
		target_intensity,
		Vector2.ZERO,
		delta,
		Vector3(shockwave_color.r, shockwave_color.g, shockwave_color.b),
		shockwave_radius,
	)