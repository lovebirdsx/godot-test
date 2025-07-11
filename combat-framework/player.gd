extends BaseCharacter

@onready var attack_manager: Node = $AttackManager

func _ready() -> void:
    super._ready()
    for attack in attack_manager.get_children():
        if attack is BaseSkill:
            attack.caster = self

func get_move_dir():
    return Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down")).normalized()

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("attack"):
        var first_attack = attack_manager.get_child(0)
        if first_attack is BaseSkill:
            first_attack.cast()
