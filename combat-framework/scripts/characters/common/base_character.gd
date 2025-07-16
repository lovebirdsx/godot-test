extends CharacterBody2D
class_name BaseCharacter

signal damage_taken(damage: float)
signal healed(amount: float, current_hp: float)
signal died

@export var data: CharacterData
@onready var movement: BaseCharacterMovement = $Movement
@onready var attr_manager: AttrManager = $AttrManager
@onready var skill_manager: SkillManager = get_node_or_null("SkillManager")
@onready var buff_manager: BuffManager = get_node_or_null("BuffManager")

var current_health: float

func _ready():
	if data == null:
		push_error("CharacterData is not set for " + name)
		return

	attr_manager.get_attr(AttrDefine.AttrType.MaxHp).set_base_value(data.max_hp)
	attr_manager.get_attr(AttrDefine.AttrType.Damage).set_base_value(data.damage)
	attr_manager.get_attr(AttrDefine.AttrType.Defense).set_base_value(data.defense)
	attr_manager.get_attr(AttrDefine.AttrType.ContactDamageInterval).set_base_value(data.contact_damage_interval)
	current_health = attr_manager.get_max_hp()
	collision_layer = data.faction.defenseLayer
	collision_mask = 0

func take_damage(damage: float) -> void:
	if current_health <= 0:
		return

	var real_damage = damage - attr_manager.get_defense()
	if real_damage < 0:
		real_damage = 1

	if real_damage > current_health:
		real_damage = current_health

	current_health -= real_damage
	damage_taken.emit(real_damage)
	EventManager.publish(GameEvents.Type.CharacterDamaged, {"character": self, "damage": real_damage})

	print(name + " took " + str(real_damage) + " damage. Health is now " + str(current_health))
	if current_health <= 0:
		die()

func heal(amount: float) -> void:
	if amount <= 0 or current_health <= 0:
		push_warning("Cannot heal " + name + " with amount: " + str(amount) + ". Current health: " + str(current_health))
		return

	current_health += amount
	var max_hp = attr_manager.get_max_hp()
	if current_health > max_hp:
		current_health = max_hp

	healed.emit(amount, current_health)
	print(name + " healed " + str(amount) + ". Health is now " + str(current_health))

func die():
	print(name + " has died.")
	died.emit()
	queue_free()

func fire_projectile(fire_data: FireProjectileData, fire_rotation: float) -> Projectile:
	var projectile = fire_data.create_projectile(self, fire_rotation)
	projectile.set_caster(self)
	get_parent().add_child(projectile)
	return projectile
