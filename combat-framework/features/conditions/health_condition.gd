extends BaseCondition
class_name HealthCondition

enum Target {
	Attacker,
	Defender
}

@export var target: HealthCondition.Target = Target.Attacker
@export var operator: Operator = Operator.LessThan
@export_range(0.0, 1.0) var percentage: float = 0.5

func is_met(context: CombatContext) -> bool:
	var character: BaseCharacter
	match target:
		Target.Attacker:
			character = context.attacker
		Target.Defender:
			character = context.defender
	
	if not is_instance_valid(character):
		push_error("HealthCondition: Target character is not valid.")
		return false
		
	var max_hp = character.attr_manager.get_attr(AttrDefine.AttrType.MaxHp).get_value()
	if max_hp == 0:
		return false
		
	var current_hp_percentage = character.current_health / max_hp
	return compare_float_by_operator(current_hp_percentage, percentage, operator)
