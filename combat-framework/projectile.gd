class_name Projectile
extends Area2D

@export var speed: float = 500.0
@export var fly_distance: float = 1000.0

var damage: float = 10.0
var direction: Vector2 = Vector2.RIGHT
var owner_faction: Faction
var start_position: Vector2

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	start_position = global_position

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	if global_position.distance_to(start_position) > fly_distance:
		queue_free()

func _on_area_entered(area: Area2D):
	if area.owner and area.owner.has_method("take_damage"):
		area.owner.take_damage(damage)

	queue_free()

func set_owner_and_damage(caster: BaseCharacter, dmg: float):
	owner_faction = caster.faction
	damage = dmg
	collision_layer = caster.faction.attackLayer
	collision_mask = caster.faction.get_attack_target_mask()
