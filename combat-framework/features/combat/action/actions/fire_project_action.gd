extends InstantAction
class_name FireProjectileAction

@export var data: FireProjectileData
@export var on_hit_actions: Array[BaseAction] = []

func _get_fire_rotation(context: CombatContext) -> float:
	var attacker: BaseCharacter = context.attacker
	if attacker == null:
		push_error("Attacker is null in FireProjectileAction")
		return 0.0
	
	if context.defender == null:
		return attacker.global_rotation
	
	var direction: Vector2 = (context.defender.global_position - attacker.global_position).normalized()
	return direction.angle()

func _on_hit_actions_finished(context: CombatContext) -> void:
	var actions_runner: ActionsRunner = ActionsRunner.new(on_hit_actions)
	actions_runner.run_actions(context)

func execute(context: CombatContext) -> void:
	var attacker: BaseCharacter = context.attacker
	var projectile: Projectile = attacker.fire_projectile(data, _get_fire_rotation(context))
	projectile.hit.connect(_on_hit_actions_finished)
