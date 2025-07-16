extends RefCounted
class_name GameEvents

enum Type {
	PlayerDied = 1, # {"character": BaseCharacter}
	EnemyDied = 2, # {"character": BaseCharacter}
	CharacterDamaged = 3, # {"character": BaseCharacter, "damage": float}
}
