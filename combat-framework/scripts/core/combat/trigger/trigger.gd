extends Resource
class_name Trigger

@export var event_type: GameEvents.Type = GameEvents.Type.PlayerDied
@export var condition: BaseCondition = null
@export var actions: Array[BaseAction] = []

func excute(context: CombatContext) -> bool:
	if condition != null and not condition.is_met(context):
		return false

	var runner = ActionsRunner.new(actions)
	runner.run_actions(context)
	return true
