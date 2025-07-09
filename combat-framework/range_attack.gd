extends BaseAttack

@export var projectile_scene: PackedScene
@export var muzzle_node: Node2D

func execute():
	var projectile = projectile_scene.instantiate()
	projectile.global_position = muzzle_node.global_position
	projectile.global_rotation = muzzle_node.global_rotation
	projectile.set_owner_and_damage(caster, caster.stats.attack_power)
	get_tree().root.add_child(projectile)
