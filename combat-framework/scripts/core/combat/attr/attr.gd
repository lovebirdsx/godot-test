extends RefCounted
class_name Attr

class Modifier extends RefCounted:
	var source: Node
	var data: AttrModifierData

	func _init(initial_source: Node, initial_data: AttrModifierData):
		source = initial_source
		data = initial_data

var base_value: float
var modifiers: Array[Modifier] = []
var dirty: bool = false
var cached_value: float = 0.0

func add_modifier(modifier: AttrModifierData, source: Object) -> void:
	modifiers.append(Modifier.new(source, modifier))
	dirty = true

func remove_modifier(modifier: AttrModifierData) -> void:
	var index = modifiers.find(func(m): return m.data == modifier)
	if index != -1:
		modifiers.remove_at(index)
		dirty = true

func remove_modifiers_by_source(source_to_remove: Object) -> void:
	var new_modifiers: Array[Modifier] = []
	var changed = false
	for m in modifiers:
		if m.source != source_to_remove:
			new_modifiers.append(m)
		else:
			changed = true
	
	if changed:
		modifiers = new_modifiers
		dirty = true

func set_base_value(value: float) -> void:
	if base_value != value:
		base_value = value
		dirty = true

func get_value() -> float:
	if not dirty:
		return cached_value

	var flat_sum: float = 0.0
	var percent_sum: float = 1.0
	for modifier in modifiers:
		if modifier.modifier_type == AttrModifierData.ModifierType.Flat:
			flat_sum += modifier.value
		elif modifier.modifier_type == AttrModifierData.ModifierType.Percent:
			percent_sum += modifier.value
	var total_value: float = (base_value + flat_sum) * percent_sum
	cached_value = total_value
	dirty = false
	return total_value