extends Sprite2D

var speed = 400
var angular_speed = PI

func _init():
	print("Hello, World!")

func _process(delta: float) -> void:
	var direction = 0
	if Input.is_action_pressed("ui_left"):
		direction = -1
	if Input.is_action_pressed("ui_right"):
		direction = 1

	rotation += angular_speed * direction * delta

	var velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		velocity = Vector2.UP.rotated(rotation) * speed
	position += velocity * delta


func _on_button_pressed() -> void:
	set_process(not is_processing())
	print("Process is now ", is_processing())
