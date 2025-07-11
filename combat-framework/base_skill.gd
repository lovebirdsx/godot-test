extends Node
class_name BaseSkill

var caster: BaseCharacter
var cd: float = 1

func can_cast() -> bool:
    return true

func cast(_target: Node2D) -> void:
    pass
