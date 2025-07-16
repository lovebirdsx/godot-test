extends Node
class_name BuffManager

@onready var character: BaseCharacter = get_parent()

var active_buffs: Dictionary[BuffData, Buff] = {}

func _ready() -> void:
	if not is_instance_valid(character):
		push_error("BuffManager's character is invalid.")
		return
	
	for buff_data in character.data.buffs:
		if not is_instance_valid(buff_data):
			push_error("Invalid BuffData instance: %s" % buff_data)
			continue
		
		add_buff.call_deferred(buff_data)

func add_buff(buff_data: BuffData) -> void:
	if not is_instance_valid(character):
		push_error("BuffManager's character is invalid.")
		return
	
	if active_buffs.has(buff_data):
		var existing_buff: Buff = active_buffs[buff_data]
		
		match buff_data.overlap_type:
			BuffData.OverlapType.Ignore:
				return
				
			BuffData.OverlapType.Replace:
				existing_buff.stop()
				_create_and_start_new_buff(buff_data)
				
			BuffData.OverlapType.Stack:
				existing_buff.add_stack()
	else:
		_create_and_start_new_buff(buff_data)


func remove_buff_by_data(buff_data: BuffData) -> void:
	if active_buffs.has(buff_data):
		active_buffs[buff_data].stop()


func _create_and_start_new_buff(buff_data: BuffData) -> void:
	var new_buff = Buff.new(buff_data, character)
	active_buffs[buff_data] = new_buff
	
	new_buff.buff_stopped.connect(_on_buff_stopped.bind(buff_data))
	new_buff.start()


func _on_buff_stopped(buff_data: BuffData) -> void:
	if active_buffs.has(buff_data):
		active_buffs.erase(buff_data)
