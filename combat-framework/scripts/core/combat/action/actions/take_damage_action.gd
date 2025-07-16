extends InstantAction
class_name TakeDamageAction

@export var damage: Damage

func execute(context: CombatContext) -> void:
	var target = get_target(context)
	if target == null:
		push_error("TakeDamageAction: Target is null.")
		return

	if target.has_method("take_damage"):
		target.take_damage(damage.get_value(context.attacker))
	else:
		push_error("Target does not have a take_damage method.")
