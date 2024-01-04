extends Node

@export var enabled: bool = true

func _ready() -> void:
    if enabled:
        GDebug.print(self, ["Debug mouse capture toggle active."])

func _unhandled_input(_event: InputEvent) -> void:
    if enabled && Input.is_action_just_pressed("ui_cancel"):
        if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
            Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
        else:
            Input.mouse_mode = Input.MOUSE_MODE_CAPTURED