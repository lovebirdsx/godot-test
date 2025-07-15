extends Resource
class_name BaseAction

enum TargetType {
	None,
	Source,
	Target,
	Trigger,
}

@export var target_type: TargetType = TargetType.Source

func get_target(context: CombatContext) -> Node:
	match target_type:
		TargetType.Source:
			return context.attacker
		TargetType.Target:
			return context.defender
		TargetType.Trigger:
			return context.trigger
		_:
			return null


