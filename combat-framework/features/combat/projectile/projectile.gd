class_name Projectile
extends Area2D

signal hit(context: CombatContext)
signal expired(context: CombatContext)

@export var speed: float = 500.0
@export var lifetime: float = 1000.0
@onready var lifetime_timer: Timer = $LifetimeTimer

var shooter: BaseCharacter
var start_position: Vector2
var combat_context: CombatContext = CombatContext.new()
var direction: Vector2

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	start_position = global_position
	direction = Vector2(cos(global_rotation), sin(global_rotation)).normalized()
	lifetime_timer.wait_time = lifetime
	lifetime_timer.timeout.connect(_on_lifetime_timeout)
	lifetime_timer.start()

func _on_lifetime_timeout() -> void:
	expired.emit(combat_context)
	queue_free()

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_body_entered(body: PhysicsBody2D):
	combat_context.defender = body
	hit.emit(combat_context)
	queue_free()

func set_caster(caster: BaseCharacter):
	combat_context.attacker = caster
	combat_context.trigger = self
	collision_layer = caster.data.faction.attackLayer
	collision_mask = caster.data.faction.get_attack_target_mask()
