extends BaseCondition
class_name AndCondition

@export var conditions: Array[BaseCondition] = []

func is_met(context: CombatContext) -> bool:
	for condition in conditions:
		if condition == null:
			push_error("A null condition was found in AndCondition!")
			continue
		if not condition.is_met(context):
			return false
	return true
