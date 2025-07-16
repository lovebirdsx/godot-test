extends BaseCondition
class_name OrCondition

@export var conditions: Array[BaseCondition] = []

func is_met(context: CombatContext) -> bool:
	if conditions.is_empty():
		push_error("OrCondition has no conditions to check!")
		return true

	for condition in conditions:
		if condition == null:
			push_error("A null condition was found in OrCondition!")
			continue
		if condition.is_met(context):
			return true
	return false
