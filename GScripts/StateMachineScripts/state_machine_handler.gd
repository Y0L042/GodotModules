class_name StateMachineHandler
extends Node

@export var node_root: Node
var current_state: StateClass

func _init() -> void:
	add_to_group(HandlerManager.IHandler) # Almost equivalent to implement IHandler

func _ready() -> void:
	# change state to initial state here
	pass

func custom_ready(i_node_root: Node):
	node_root = i_node_root

func custom_process(_delta: float):
	if current_state: current_state.custom_process(_delta)

func custom_physics_process(_delta: float):
	if current_state: current_state.custom_physics_process(_delta)

func custom_unhandled_input(_event: InputEvent) -> void:
	if current_state: current_state.custom_unhandled_input(_event)

func change_state(i_new_state: StateClass) -> void:
	if current_state: current_state.exit();
	current_state = i_new_state
	if current_state: current_state.enter()
