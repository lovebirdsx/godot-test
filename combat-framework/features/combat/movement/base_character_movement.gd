extends Node
class_name BaseCharacterMovement

@onready var attr_manager: AttrManager = get_parent().get_node("AttrManager")
@onready var character: BaseCharacter = get_parent()

func _ready() -> void:
	var stats = character.data
	if stats:
		attr_manager.get_attr(AttrDefine.AttrType.MovementSpeed).set_base_value(stats.movement_speed)

func get_move_dir() -> Vector2:
	return Vector2.ZERO

func _physics_process(_delta: float) -> void:
	var move_dir = get_move_dir()
	character.velocity = move_dir * attr_manager.get_attr(AttrDefine.AttrType.MovementSpeed).get_value()
	character.move_and_slide()
