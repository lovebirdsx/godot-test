extends Node
class_name Target

enum TargetType {
	None,
	Source,
	Target,
	Trigger,
}

static func get_target(context: CombatContext, target_type: TargetType) -> Node:
	match target_type:
		TargetType.Source:
			return context.attacker
		TargetType.Target:
			return context.defender
		TargetType.Trigger:
			return context.trigger
		_:
			return null
