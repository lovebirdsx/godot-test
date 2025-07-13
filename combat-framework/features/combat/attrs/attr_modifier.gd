extends RefCounted
class_name AttrModifier

enum ModifierType {
	Flat,
	Percent,
}

var attr_type: AttrDefine.AttrType
var value: float
var modifier_type: ModifierType
var source: Node
