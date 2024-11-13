extends Node2D

class_name CustomNode

@export var res: CustomResource
var damage: float = 0

func _ready() -> void:
	print('Custom Node _ready')
	if res:
		print('damage = ', res.damage)


func _process(_delta: float) -> void:
	if res and res.damage != damage:
		print('damage change from ', damage, ' to ', res.damage)
		damage = res.damage
