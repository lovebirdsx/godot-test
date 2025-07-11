extends Node

class_name SkillManager

func cast_skill(index: int, target: Node2D) -> void:
	var skill = get_child(index)
	if skill is BaseSkill:
		skill.cast(target)
	else:
		push_error("Skill at index %d is not a valid BaseSkill." % index)
