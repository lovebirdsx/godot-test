extends Area2D

var target_areas: Array[Area2D] = []

@onready var attack_timer: Timer = $AttackTimer

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	var character = owner as BaseCharacter
	if character and character.faction:
		collision_layer = character.faction.attackLayer
		collision_mask = character.faction.get_attack_target_mask()

func _on_area_entered(area: Area2D):
	if area not in target_areas:
		target_areas.append(area)
		if target_areas.size() == 1:
			var character = owner as BaseCharacter
			if not character or not character.stats:
				return
			attack_timer.wait_time = character.stats.contact_damage_interval
			attack_timer.start()

func _on_area_exited(area: Area2D):
	if area in target_areas:
		target_areas.erase(area)
		if target_areas.size() == 0:
			attack_timer.stop()

func _on_attack_timer_timeout() -> void:
	var character = owner as BaseCharacter
	if not character or not character.stats:
		return

	var stats = character.stats
	for area in target_areas:
		if area.owner and area.owner.has_method("take_damage"):
			area.owner.take_damage(stats.contact_damage)
