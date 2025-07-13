extends Node
class_name TagManager

enum TagType {
	InVisible,	# Tag for invisible characters
	Immutable,	# Tag for immutable objects
}

signal tag_added(tag: TagType)
signal tag_removed(tag: TagType)

@export var tags: Array[TagType] = []

func has_tag(tag: TagType) -> bool:
	return tag in tags

func add_tag(tag: TagType) -> void:
	if not has_tag(tag):
		tags.append(tag)
		tag_added.emit(tag)

func remove_tag(tag: TagType) -> void:
	if has_tag(tag):
		tags.erase(tag)
		tag_removed.emit(tag)
