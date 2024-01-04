@tool
@icon(".icons/icons8-spanner-100.png")
class_name EditorOnlyNodes
extends Node3D

func _ready() -> void:
	if !Engine.is_editor_hint():
		queue_free()
