extends Resource
class_name Faction

enum FactionType {
    NONE = 0,
    PLAYER = 1 << 0,
    ENEMY = 1 << 1,
    PET = 1 << 2,
    PLAYER_HITBOX = 1 << 3,
    ENEMY_HITBOX = 1 << 4,
    PET_HITBOX = 1 << 5,
    COLLECTABLE = 1 << 6,
}

@export var attackLayer: FactionType = FactionType.NONE
@export var attackTargets: Array[FactionType] = []
@export var defenseLayer: FactionType = FactionType.NONE

func can_attack(target: FactionType) -> bool:
    if attackTargets.is_empty() or not target:
        return false
    return target in attackTargets

func get_attack_target_mask() -> int:
    var mask: int = 0
    for target in attackTargets:
        mask |= target
    return mask
