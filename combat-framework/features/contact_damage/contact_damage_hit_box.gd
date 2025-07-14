extends Area2D

var target_characters: Array[BaseCharacter] = []

@onready var attack_timer: Timer = $AttackTimer
@onready var source: BaseCharacter = owner as BaseCharacter

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	var faction = source.stats.faction
	collision_layer = faction.attackLayer
	collision_mask = faction.get_attack_target_mask()

func _on_body_entered(body: Node2D):
	if body not in target_characters and body is BaseCharacter:
		target_characters.append(body)
		if target_characters.size() == 1:
			attack_timer.wait_time = source.stats.contact_damage_interval
			attack_timer.start()

func _on_body_exited(body: Node2D):
	if body in target_characters:
		target_characters.erase(body)
		if target_characters.size() == 0:
			attack_timer.stop()

func _on_attack_timer_timeout() -> void:
	for chr in target_characters:
		chr.take_damage(source.attr_manager)
