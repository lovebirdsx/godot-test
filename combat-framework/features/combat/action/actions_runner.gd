extends RefCounted
class_name ActionsRunner

signal actions_finished

var actions: Array[BaseAction] = []
var current_action_index: int = 0
var is_running: bool = false

func _init(initial_actions: Array[BaseAction]) -> void:
	actions = initial_actions

func run_actions(context: CombatContext) -> void:
	if is_running:
		return

	is_running = true
	current_action_index = 0
	_process_next_action(context)

func _process_next_action(context: CombatContext) -> void:
	if current_action_index >= actions.size():
		is_running = false
		actions_finished.emit()
		return

	var action = actions[current_action_index]
	if action is InstantAction:
		action.execute(context)
		current_action_index += 1
		_process_next_action(context)
	elif action is SustainedAction:
		action.execute(context)
		action.finished.connect(
			func():
				current_action_index += 1
				_process_next_action(context)
		)
	else:
		push_error("Unknown action type: " + str(action))
		current_action_index += 1
		_process_next_action(context)
