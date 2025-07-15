extends Resource
class_name BuffData

@export var name: String = "Base Buff"
@export var modifiers: Array[AttrModifierData] = []
@export var on_add_actions: Array[BaseAction] = []
@export var on_remove_actions: Array[BaseAction] = []
@export var duration: float = 0.0
@export var max_stacks: int = 1
@export var icon: Texture2D = null
