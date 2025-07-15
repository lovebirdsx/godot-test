extends RefCounted
class_name Skill

signal casted(succeed: bool, reason: String)
signal cd_finished

var data: SkillData
var character: BaseCharacter
var timer: Timer
var runner: ActionsRunner
var cd_remaining: float = 0.0

func _init(initial_character: BaseCharacter, initial_data: SkillData) -> void:
	data = initial_data
	timer = Timer.new()
	initial_character.add_child.call_deferred(timer)
	runner = ActionsRunner.new(data.actions)
	character = initial_character
	timer.timeout.connect(
		func():
			timer.stop()
			cd_finished.emit()
	)

func can_cast() -> bool:
	return timer.time_left <= 0

func cast() -> void:
	if not can_cast():
		push_error("Cannot cast skill: " + data.name)
		return
	
	if runner.is_running:
		push_error("Actions are already running for skill: " + data.name)
		return
	
	timer.start(data.cd)
	var context = CombatContext.new()
	context.attacker = character
	context.defender = data.target.get_target(character)
	runner.run_actions(context)
	runner.actions_finished.connect(
		func():
			casted.emit(true, "")
	)
