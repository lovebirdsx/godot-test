extends BaseCondition
class_name NotCondition

@export var condition: BaseCondition

func is_met(context: CombatContext) -> bool:
	if condition == null:
		push_error("NotCondition has no condition to check!")
		return false
	return not condition.is_met(context)
