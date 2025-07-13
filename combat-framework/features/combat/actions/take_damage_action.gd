extends InstantAction
class_name TakeDamageAction

@export var damage: float = 10.0

func execute(context: CombatContext) -> void:
	var taget = Target.get_target(context, target_type)
	if taget.has_method("take_damage"):
		taget.take_damage(damage)
	else:
		push_error("Target does not have a take_damage method.")
