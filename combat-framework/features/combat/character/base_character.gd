extends CharacterBody2D
class_name BaseCharacter

signal damage_taken(damage: float, src_attr_manager: AttrManager)
signal died

@export var stats: CharacterStats
@onready var movement: BaseCharacterMovement = $Movement
@onready var attr_manager: AttrManager = $AttrManager
@onready var skill_manager: SkillManager = get_node_or_null("SkillManager")
@onready var buff_manager: BuffManager = get_node_or_null("BuffManager")

var current_health: float

func _ready():
	attr_manager.get_attr(AttrDefine.AttrType.MaxHp).set_base_value(stats.max_health)
	attr_manager.get_attr(AttrDefine.AttrType.Damage).set_base_value(stats.damage)
	attr_manager.get_attr(AttrDefine.AttrType.Defense).set_base_value(stats.defense)
	attr_manager.get_attr(AttrDefine.AttrType.ContactDamageInterval).set_base_value(stats.contact_damage_interval)
	current_health = attr_manager.get_attr(AttrDefine.AttrType.MaxHp).get_value()
	collision_layer = stats.faction.defenseLayer
	collision_mask = 0

func take_damage(src_attr_manager: AttrManager) -> void:
	if current_health <= 0:
		return
	
	var damage = src_attr_manager.get_damage() - attr_manager.get_defense()
	if damage < 0:
		damage = 1

	if damage > current_health:
		damage = current_health

	current_health -= damage
	damage_taken.emit(damage, src_attr_manager)

	print(name + " took " + str(damage) + " damage. Health is now " + str(current_health))
	if current_health <= 0:
		die()

func die():
	print(name + " has died.")
	died.emit()
	queue_free()

func fire_projectile(projectile_scene: PackedScene) -> void:
	var projectile = projectile_scene.instantiate()
	projectile.position = position
	projectile.rotation = rotation
	get_parent().add_child(projectile)
