extends Node
class_name AttrManager

var attr_map: Dictionary[AttrDefine.AttrType, Attr] = {}

func get_attr(attr_type: AttrDefine.AttrType) -> Attr:
	if attr_type not in attr_map:
		attr_map[attr_type] = Attr.new()
	return attr_map[attr_type]

func get_damage() -> float:
	return get_attr(AttrDefine.AttrType.Damage).get_value()

func get_defense() -> float:
	return get_attr(AttrDefine.AttrType.Defense).get_value()
