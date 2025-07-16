@tool

extends Resource
class_name FireProjectileData

enum FirePositionType {
	Socket,
}

@export var scene: PackedScene : set = _set_scene
@export var speed: float = 400.0
@export var lifetime: float = 2.0
@export var fire_position_type: FirePositionType = FirePositionType.Socket

## The node path to the fire point when using FirePositionType.Socket
@export var socket: NodePath = "FirePoint"

func _set_scene(value: PackedScene) -> void:
	if value != null:
		var instance = value.instantiate()
		if not instance is Projectile:
			push_error("Warning: Scene is not a Projectile.")
			instance.queue_free()
			return
		instance.queue_free()
	scene = value

func _get_spawn_position(caster: BaseCharacter) -> Vector2:
	if fire_position_type == FirePositionType.Socket:
		var fire_point: Node2D = caster.get_node_or_null(socket)
		if not fire_point is Node2D:
			push_error("Fire point node not found or is not a Node2D: " + str(socket))
			return caster.global_position
		return fire_point.global_position
	else:
		return caster.global_position

func create_projectile(caster: BaseCharacter, rotation: float) -> Projectile:
	var projectile: Projectile = scene.instantiate()
	projectile.speed = speed
	projectile.lifetime = lifetime
	projectile.global_position = _get_spawn_position(caster)
	projectile.global_rotation = rotation
	return projectile
