extends Node

var _subscribers: Dictionary = {} # { GameEvents.Type: [Callable, ...] }

func subscribe(event_type: GameEvents.Type, callable: Callable):
	if not _subscribers.has(event_type):
		_subscribers[event_type] = []

	if not _subscribers[event_type].has(callable):
		_subscribers[event_type].append(callable)

func unsubscribe(event_type: GameEvents.Type, callable: Callable):
	if _subscribers.has(event_type) and _subscribers[event_type].has(callable):
		_subscribers[event_type].erase(callable)
		if _subscribers[event_type].size() == 0:
			_subscribers.erase(event_type)

func publish(event_type: GameEvents.Type, payload: Dictionary):
	if not _subscribers.has(event_type):
		return
	
	var callables = _subscribers[event_type].duplicate()
	for callable in callables:
		if callable.is_valid():
			callable.call(payload)
