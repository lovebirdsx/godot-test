extends RefCounted
class_name Attr

var base_value: float
var modifiers: Array[AttrModifier] = []
var dirty: bool = false
var cached_value: float = 0.0

func add_modifier(modifier: AttrModifier) -> void:
	modifiers.append(modifier)
	dirty = true

func remove_modifier(modifier: AttrModifier) -> void:
	modifiers.erase(modifier)
	dirty = true

func remove_modifiers_by_source(source: Node) -> void:
	modifiers = modifiers.filter(func(m): return m.source != source)
	dirty = true

func get_value() -> float:
	if not dirty:
		return cached_value

	var flat_sum: float = 0.0
	var percent_sum: float = 1.0
	for modifier in modifiers:
		if modifier.modifier_type == AttrModifier.ModifierType.Flat:
			flat_sum += modifier.value
		elif modifier.modifier_type == AttrModifier.ModifierType.Percent:
			percent_sum += modifier.value
	var total_value: float = (base_value + flat_sum) * (1 + percent_sum)
	cached_value = total_value
	dirty = false
	return total_value