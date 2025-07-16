extends Node
class_name SkillManager

@onready var character: BaseCharacter = get_parent()
var skills: Array[Skill] = []
var auto_cast_skills: Array[AutoCastSkill] = []

class AutoCastSkill extends RefCounted:
	var skill: Skill
	var is_active: bool = false

	func _init(init_skill: Skill) -> void:
		skill = init_skill
	
	func start() -> void:
		if is_active:
			return

		is_active = true
		if skill.can_cast():
			skill.cast()
		skill.cd_finished.connect(_on_cd_finished)
		
	func stop() -> void:
		if not is_active:
			return

		is_active = false
		skill.cd_finished.disconnect(_on_cd_finished)

	func _on_cd_finished() -> void:
		if skill.can_cast():
			skill.cast()
		else:
			# Re-check the cooldown after a short delay
			skill.character.get_tree().create_timer(0.2).timeout.connect(_on_cd_finished)

func _ready() -> void:
	for skill_data in character.data.skills:
		var skill = Skill.new(character, skill_data)
		skills.append(skill)

	for skill_data in character.data.auto_cast_skills:
		if skill_data not in character.data.skills:
			push_error("Auto-cast skill %s is not defined in character's skills." % skill_data.name)
			continue
		var existing_skill = null
		for s in skills:
			if s.data == skill_data:
				existing_skill = s
				break
		if existing_skill:
			var auto_cast_skill = AutoCastSkill.new(existing_skill)
			auto_cast_skills.append(auto_cast_skill)
	
	_start_auto_cast_skills.call_deferred()

func _start_auto_cast_skills() -> void:
	for auto_cast_skill in auto_cast_skills:
		auto_cast_skill.start()

func cast_skill(skill_index: int) -> void:
	if skill_index < 0 or skill_index >= skills.size():
		push_error("Invalid skill index: %d" % skill_index)
		return

	var skill = skills[skill_index]
	if !skill.can_cast():
		push_error("Skill %d cannot be cast." % skill_index)
		return

	skill.cast()
