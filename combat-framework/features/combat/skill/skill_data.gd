extends Resource
class_name SkillData

@export var name: String
@export var description: String
@export var icon: Texture2D
@export var cd: float = 0.0
@export var target: Target
@export var actions: Array[BaseAction] = []
