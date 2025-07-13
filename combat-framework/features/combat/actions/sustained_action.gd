extends BaseAction
class_name SustainedAction

signal finished

func execute(_context: CombatContext) -> void:
	finished.emit()
