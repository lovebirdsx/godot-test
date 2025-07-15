extends Resource
class_name Damage

enum DamageType {
	Physical,
}

enum DamageSource {
	Absolute,
	RelativeToCharacter,
}

@export var type: DamageType = DamageType.Physical
@export var source: DamageSource = DamageSource.RelativeToCharacter
@export var value_or_rate: float = 1

func get_value(character: BaseCharacter) -> float:
	if source == DamageSource.Absolute:
		return value_or_rate
	elif source == DamageSource.RelativeToCharacter:
		return character.attr_manager.get_damage() * value_or_rate
	else:
		push_error("Unknown damage source type.")
		return 0.0
