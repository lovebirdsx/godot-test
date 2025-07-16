extends InstantAction
class_name HealAction

@export var amount: Damage;

func execute(context: CombatContext) -> void:
	var target = get_target(context)
	if target == null:
		push_error("HealAction: Target is null.")
		return

	if target.has_method("heal"):
		target.heal(amount.get_value(target))
	else:
		push_error("Target does not have a heal method.")
