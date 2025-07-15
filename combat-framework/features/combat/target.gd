extends Resource
class_name Target

enum TargetType {
	None,
	Self,
	NearestEnemy,
	NearestEnemyByRangeAttr,
	Player,
}

@export var type: TargetType = TargetType.None

## Distance to search for nearest enemy, used by NearestEnemy
@export var distance: float = 100

func get_target(caster: Node2D) -> Node:
	match type:
		TargetType.Self:
			return caster
		TargetType.NearestEnemy:
			return get_nearest_enemy(caster, 1000000)
		TargetType.Player:
			return get_player(caster)
		_:
			return null

func get_nearest_enemy(caster: Node2D, p_range: float = 100) -> Node:
	var enemies = caster.get_tree().get_nodes_in_group("enemy")
	var nearest_enemy: Node = null
	var min_distance_squared: float = p_range * p_range
	for enemy in enemies:
		var dist = caster.position.distance_squared_to(enemy.position)
		if dist < min_distance_squared:
			min_distance_squared = dist
			nearest_enemy = enemy
	return nearest_enemy

func get_player(caster: Node2D) -> Node:
	var node = caster.get_tree().get_node_or_null("/root/Player")
	if node and node.is_inside_tree():
		return node
	return null
