class_name HandlerManager
extends Node3D

static var IHandler: String = "IHandler"

@export var node_root: Node

signal signal_custom_init()
signal signal_custom_ready(node_root)
signal signal_custom_process(_delta)
signal signal_custom_physics_process(_delta: float)
signal signal_custom_handled_input(_event: InputEvent)
signal signal_custom_unhandled_input(_event: InputEvent)

func _ready() -> void:
	add_handlers()
	signal_custom_ready.emit(node_root)

func _process(_delta: float) -> void:
	signal_custom_process.emit(_delta)

func _physics_process(_delta: float) -> void:
	signal_custom_physics_process.emit(_delta)

func _handled_input(_event: InputEvent) -> void:
	signal_custom_handled_input.emit(_event)

func _unhandled_input(_event: InputEvent) -> void:
	signal_custom_unhandled_input.emit(_event)

func add_handlers() -> void:
	for handler in get_children():
		if handler.is_in_group(IHandler):
			if handler.has_method("custom_init"):
				signal_custom_init.connect(handler.custom_init)
			if handler.has_method("custom_ready"):
				signal_custom_ready.connect(handler.custom_ready)
			if handler.has_method("custom_process"):
				signal_custom_process.connect(handler.custom_process)
			if handler.has_method("custom_physics_process"):
				signal_custom_physics_process.connect(handler.custom_physics_process)
			if handler.has_method("custom_handled_input"):
				signal_custom_handled_input.connect(handler.custom_handled_input)
			if handler.has_method("custom_unhandled_input"):
				signal_custom_unhandled_input.connect(handler.custom_unhandled_input)
