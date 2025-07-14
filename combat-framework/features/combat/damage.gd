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
