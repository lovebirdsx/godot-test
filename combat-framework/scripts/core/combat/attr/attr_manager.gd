extends Node
class_name AttrManager

var attr_map: Dictionary[AttrDefine.AttrType, Attr] = {}

func get_attr(attr_type: AttrDefine.AttrType) -> Attr:
	if attr_type not in attr_map:
		attr_map[attr_type] = Attr.new()
	return attr_map[attr_type]

func get_max_hp() -> float:
	return get_attr(AttrDefine.AttrType.MaxHp).get_value()

func get_damage() -> float:
	return get_attr(AttrDefine.AttrType.Damage).get_value()

func get_defense() -> float:
	return get_attr(AttrDefine.AttrType.Defense).get_value()

func add_modifier(attr_type: AttrDefine.AttrType, modifier: AttrModifierData, source: RefCounted) -> void:
	var attr = get_attr(attr_type)
	attr.add_modifier(modifier, source)

func remove_modifier(attr_type: AttrDefine.AttrType, modifier: AttrModifierData) -> void:
	var attr = get_attr(attr_type)
	attr.remove_modifier(modifier)

func remove_modifiers_by_source(attr_type: AttrDefine.AttrType, source_to_remove: RefCounted) -> void:
	var attr = get_attr(attr_type)
	attr.remove_modifiers_by_source(source_to_remove)
