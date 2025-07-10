extends BaseCharacter

@onready var decision_timer: Timer = $DecisionTimer
var move_dir: Vector2 = Vector2.ZERO

func _ready() -> void:
	super._ready()
	decision_timer.start()
	decision_timer.timeout.connect(_on_decision_timeout)

func _find_closest_enemy() -> BaseCharacter:
	var closest_enemy: BaseCharacter = null
	var closest_distance: float = INF
	
	for enemy in get_tree().get_nodes_in_group("enemy"):
		var distance = global_position.distance_to(enemy.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy
	
	return closest_enemy

func _on_decision_timeout() -> void:
	var enemy = _find_closest_enemy()
	if enemy:
		move_dir = (enemy.global_position - global_position).normalized()
	else:
		move_dir = Vector2.ZERO

# 朝最近的敌人移动，0.5秒做一次决策
func get_move_dir():
	return move_dir
