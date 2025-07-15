extends Resource
class_name AttrModifierData

enum ModifierType {
	Flat,
	Percent,
}

var attr_type: AttrDefine.AttrType
var modifier_type: ModifierType
var value: float
