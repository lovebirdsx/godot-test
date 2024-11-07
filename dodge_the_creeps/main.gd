extends Node


@export var mob_scene: PackedScene
var score = 0


func _ready() -> void:
	pass


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$Hud.show_game_over()


func new_game():
	get_tree().call_group("mobs", "queue_free")
	
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	$Hud.update_score(score)
	$Hud.show_message("Get Ready")


func _on_score_timer_timeout() -> void:
	score += 1
	$Hud.update_score(score)


func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()


func _on_mob_timer_timeout() -> void:
	var mob: RigidBody2D = mob_scene.instantiate()

	var mob_spawn_location: PathFollow2D = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	var direction = mob_spawn_location.rotation + PI / 2
	print("direction: ", rad_to_deg(direction))
	
	mob.position = mob_spawn_location.position
	
	direction += randf_range(-PI/4, PI/4)
	mob.rotation = direction
	
	var velocity = Vector2(randf_range(150, 250), 0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)
