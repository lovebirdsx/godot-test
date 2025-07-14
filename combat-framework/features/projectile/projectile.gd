class_name Projectile
extends Area2D

signal hit(context: CombatContext)
signal expired(context: CombatContext)

@export var speed: float = 500.0
@export var lifetime: float = 1000.0
@onready var lifetime_timer: Timer = $LifetimeTimer

var direction: Vector2 = Vector2.RIGHT
var shooter: BaseCharacter
var start_position: Vector2
var combat_context: CombatContext = CombatContext.new()

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	start_position = global_position
	lifetime_timer.timeout.connect(_on_lifetime_timeout)

func _on_lifetime_timeout() -> void:
	expired.emit(combat_context)
	queue_free()

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_body_entered(body: PhysicsBody2D):
	combat_context.defender = body
	hit.emit(combat_context)
	queue_free()

func set_owner_and_damage(caster: BaseCharacter, damage: Damage):
	combat_context.attacker = caster
	combat_context.trigger = self
	combat_context.damage = damage
	collision_layer = caster.faction.attackLayer
	collision_mask = caster.faction.get_attack_target_mask()
