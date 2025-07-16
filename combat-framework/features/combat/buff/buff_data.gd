extends Resource
class_name BuffData

enum OverlapType {
	## Replace the existing buff with the new one.
	Replace,
	## Stack the new buff on top of the existing one.
	Stack,
	## Ignore the new buff if one already exists.
	Ignore
}

@export var name: String = "Base Buff"
@export var icon: Texture2D = null

## If duration is greater than 0, the buff will be removed after this duration.
@export var duration: float = 0.0
@export var overlap_type: OverlapType = OverlapType.Replace

## Maximum number of stacks for this buff if overlap_type is Stack.
@export var max_stacks: int = 1

@export var modifiers: Dictionary[AttrDefine.AttrType, AttrModifierData] = {}
@export var on_add_actions: Array[BaseAction] = []
@export var on_remove_actions: Array[BaseAction] = []
@export var triggers: Array[Trigger] = []
@export var max_trigger_count: int = 1

## if interval is greater than 0, the buff will apply its actions at this interval.
@export var interval = 0.0
@export var interval_actions: Array[BaseAction] = []
