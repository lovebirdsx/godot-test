extends Area2D
class_name Bullet

@export var speed: float = 800
@export var fly_range: float = 200
@export var explosion_effect_scene: PackedScene = preload("res://explosion/explosion.tscn")

@onready var shockwave_manager: ShockwaveManager = get_node("/root/GeometryWar/ShockwaveManager")

var direction: Vector2 = Vector2.UP

func _ready() -> void:
	var fly_time = fly_range / speed
	rotation = direction.angle()
	await get_tree().create_timer(fly_time).timeout
	queue_free()
	_play_explosion_effect()

func _play_explosion_effect() -> void:
	if explosion_effect_scene:
		var explosion_instance = explosion_effect_scene.instantiate()
		explosion_instance.global_position = global_position
		get_parent().add_child(explosion_instance)

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