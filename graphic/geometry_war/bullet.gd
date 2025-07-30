extends Area2D
class_name Bullet

@export var speed: float = 800
@export var fly_range: float = 200

@onready var shockwave_manager: ShockwaveManager = get_node("/root/GeometryWar/ShockwaveManager")

var direction: Vector2 = Vector2.UP

func _ready() -> void:
	var fly_time = fly_range / speed
	rotation = direction.angle()
	await get_tree().create_timer(fly_time).timeout
	queue_free()

func _process(delta: float) -> void:
	global_position += direction * speed * delta

func _exit_tree() -> void:
	shockwave_manager.create_shockwave(
		global_position, 
		1.0, 
		Vector2.ZERO, 
		1.5,
		Vector3(0.4, 0.9, 1.0),
		0.15,
	)