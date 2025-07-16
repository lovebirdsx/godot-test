extends InstantAction
class_name OpBuffAction

enum Type {
	Add,
	Remove,
}

@export var type: Type
@export var buff: BuffData

func execute(context: CombatContext) -> void:
	var target: BaseCharacter = get_target(context)
	if target == null:
		push_error("OpBuffAction: Target is null.")
		return

	if target.buff_manager == null:
		push_error("Target does not have a buff manager.")
		return

	if type == Type.Add:
		target.buff_manager.add_buff(buff)
	elif type == Type.Remove:
		target.buff_manager.remove_buff_by_data(buff)
	
