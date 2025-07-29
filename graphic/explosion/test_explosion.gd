extends Node2D

var explosion_scene: PackedScene = preload("res://explosion/explosion.tscn")
var auto_play_timer: Timer

func _ready() -> void:
	auto_play_timer = Timer.new()
	auto_play_timer.wait_time = 2.0
	auto_play_timer.one_shot = false
	auto_play_timer.timeout.connect(_on_auto_play_timeout)
	add_child(auto_play_timer)
	auto_play_timer.start()

func _play_explosion(pos: Vector2) -> void:
	var explosion_instance = explosion_scene.instantiate()
	explosion_instance.position = pos
	get_tree().current_scene.add_child(explosion_instance)

func _on_auto_play_timeout() -> void:
	var width = get_viewport().size.x
	var height = get_viewport().size.y
	var pos = Vector2(width / 2, height / 2)
	_play_explosion(pos)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		var mouse_position = get_global_mouse_position()
		_play_explosion(mouse_position)
