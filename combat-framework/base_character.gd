extends CharacterBody2D
class_name BaseCharacter

signal died

@export var stats: CharacterStats
@export var faction: Faction

var current_health: float
@onready var hurt_box: Area2D = $HurtBox

func _ready():
	if stats:
		current_health = stats.max_health
	set_faction_collision()

func _physics_process(_delta: float) -> void:
	if not stats:
		return;

	var move_dir = get_move_dir()
	velocity = move_dir * stats.movement_speed
	move_and_slide()
	
func get_move_dir():
	return Vector2.ZERO

func take_damage(damage_amount: float, source_faction: Faction):
	if source_faction.can_attack(faction.defenseLayer):
		current_health -= damage_amount
		print(name + " took " + str(damage_amount) + " damage. Health is now " + str(current_health))
		if current_health <= 0:
			die()

func die():
	print(name + " has died.")
	emit_signal("died")
	queue_free()

func set_faction_collision():
	hurt_box.collision_layer = faction.defenseLayer
