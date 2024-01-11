extends Node

@export var enabled: bool = true
@export var captured_by_default: bool = true

func _ready() -> void:
	if enabled:
		if captured_by_default:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		GDebug.print(self, ["Debug mouse capture toggle active."])

func _unhandled_input(_event: InputEvent) -> void:
	if enabled && Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
