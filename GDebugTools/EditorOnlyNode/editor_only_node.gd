@tool
@icon("res://GodotModules/GDebugTools/EditorOnlyNode/icons/icons8-spanner-100.png")
class_name EditorOnlyNodes
extends Node3D

@export var enabled: bool = true

func _ready() -> void:
	if !enabled:
		push_warning("EditorOnlyNode is disabled: ", self)
	if !Engine.is_editor_hint() and enabled:
		queue_free()
