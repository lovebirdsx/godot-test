extends BaseCondition
class_name TargetDistanceCondition

@export var operator: Operator = Operator.LessThan
@export var distance: float = 100.0

func is_met(context: CombatContext) -> bool:
	if not is_instance_valid(context.attacker) or not is_instance_valid(context.defender):
		return false

	var actual_distance_sq = context.attacker.global_position.distance_squared_to(context.defender.global_position)
	var required_distance_sq = distance * distance
	return compare_float_by_operator(actual_distance_sq, required_distance_sq, operator)
