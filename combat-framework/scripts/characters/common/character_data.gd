extends Resource

class_name CharacterData

@export var faction: Faction = Faction.new()

@export var max_hp: float = 100.0
@export var damage: float = 10.0
@export var defense: float = 5.0
@export var movement_speed: float = 200.0

@export var contact_damage_interval: float = 1.0
@export var skills: Array[SkillData] = []
@export var auto_cast_skills: Array[SkillData] = []

@export var buffs: Array[BuffData] = []
