extends RefCounted
class_name Buff

signal buff_stopped

var data: BuffData
var character: BaseCharacter
var current_stacks: int = 0

var _duration_timer: Timer
var _interval_timer: Timer

var _subscriptions: Array[Dictionary] = []
var _is_running := false
var combat_context: CombatContext

func _init(initial_data: BuffData, initial_character: BaseCharacter):
	data = initial_data
	character = initial_character
	
	_duration_timer = Timer.new()
	_duration_timer.one_shot = true
	_duration_timer.timeout.connect(_on_duration_timeout)
	character.add_child(_duration_timer)

	_interval_timer = Timer.new()
	_interval_timer.timeout.connect(_on_interval_tick)
	character.add_child(_interval_timer)

	combat_context = CombatContext.new()
	combat_context.attacker = character
	combat_context.defender = character

func start() -> void:
	if _is_running:
		return

	_is_running = true
	add_stack()
	_subscribe_to_triggers()


func stop() -> void:
	if not _is_running:
		return

	_is_running = false
	
	_duration_timer.stop()
	_interval_timer.stop()
	
	_remove_modifiers()
	_unsubscribe_from_triggers()
	_run_actions(data.on_remove_actions)
	
	_duration_timer.queue_free()
	_interval_timer.queue_free()
	
	buff_stopped.emit()


func add_stack() -> void:
	if data.overlap_type == BuffData.OverlapType.Stack and current_stacks >= data.max_stacks:
		refresh_duration()
		return

	if current_stacks == 0:
		_run_actions(data.on_add_actions)

	current_stacks = min(current_stacks + 1, data.max_stacks)
	
	_apply_modifiers()
	refresh_duration()
	_start_interval_timer()


func refresh_duration() -> void:
	if data.duration > 0:
		_duration_timer.start(data.duration)


func _on_duration_timeout() -> void:
	stop()


func _on_interval_tick() -> void:
	_run_actions(data.interval_actions)


func _run_actions(actions: Array[BaseAction]) -> void:
	if actions.is_empty():
		return
	var runner = ActionsRunner.new(actions)
	runner.run_actions(combat_context)


func _apply_modifiers() -> void:
	if character == null or character.attr_manager == null:
		return

	for modifier in data.modifiers:
		character.attr_manager.add_modifier(modifier, self)


func _remove_modifiers() -> void:
	if character == null or character.attr_manager == null:
		return

	character.attr_manager.remove_modifiers_by_source(self)


func _subscribe_to_triggers() -> void:
	for trigger in data.triggers:
		if trigger.actions.is_empty():
			continue
		
		var callable = func(_payload: Dictionary):
			trigger.excute(combat_context)

		_subscriptions.append({"event_type": trigger.event_type, "callable": callable})
		EventManager.subscribe(trigger.event_type, callable)


func _unsubscribe_from_triggers() -> void:
	for sub in _subscriptions:
		EventManager.unsubscribe(sub.event_type, sub.callable)
	_subscriptions.clear()


func _start_interval_timer() -> void:
	if data.interval > 0 and not data.interval_actions.is_empty():
		_interval_timer.wait_time = data.interval
		_interval_timer.start()
		_on_interval_tick()
