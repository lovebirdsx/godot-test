extends Resource
class_name FireProjectileData

enum FirePositionType {
	Socket,
}

@export var scene: PackedScene
@export var speed: float = 400.0
@export var lifetime: float = 2.0
@export var fire_position_type: FirePositionType = FirePositionType.Socket
@export var socket: NodePath = "FirePoint"