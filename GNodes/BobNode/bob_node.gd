@tool
extends Node3D

@export_group("Node References")
@export var node_target: Node3D

@export_group("Bob Config")
@export var enable_bob: bool = false
@export_subgroup("Global Bob")
@export var global_bob_freq: float = 1
@export var global_bob_ampl: float = 1
@export_subgroup("Vertical Bob")
@export var enable_vertical_bob: bool = true
@export var vertical_bob_freq: float = 1
@export var vertical_bob_ampl: float = 1
@export_subgroup("Horizontal Bob")
@export var enable_horizontal_bob: bool = true
@export var horizontal_bob_freq: float = 1
@export var horizontal_bob_ampl: float = 1

@export_group("Editor Tools")
var _editor_preview_enabled: bool = false
## Warning: This modifies the target node's actual origin. It saves the original origin when loading the scene, and reset it when preview is disabled. Use with caution.
@export var enable_editor_preview: bool:
	get:
		return _editor_preview_enabled
	set(enabled):
		_editor_preview_enabled = enabled
		if enabled:
			_node_target_original_transform = node_target.transform
		if !enabled:
			node_target.transform = _node_target_original_transform

var global_bob_freq_modifier: float = 1
var global_bob_ampl_modifier: float = 1
var vertical_bob_freq_modifier: float = 1
var vertical_bob_ampl_modifier: float = 1
var horizontal_bob_freq_modifier: float = 1
var horizontal_bob_ampl_modifier: float = 1
var bob_rad_t: float = 0
var node_target_original_position: Vector3

var _node_target_original_transform: Transform3D

func _ready() -> void:
	if node_target: _node_target_original_transform = node_target.transform
	if node_target: node_target_original_position = node_target.position

func _physics_process(delta: float) -> void:
	_editor_functions(delta)
	if Engine.is_editor_hint: return
	if enable_bob and node_target: bob(delta)

func bob(delta: float) -> void:
	bob_rad_t = wrap(bob_rad_t + delta, 0, PI * 1000)
	var bob_offset: Vector3 = bob_x(bob_rad_t) * float(enable_horizontal_bob) + bob_y(bob_rad_t) * float(enable_vertical_bob)
	node_target.transform.origin = node_target_original_position + bob_offset

func bob_y(i_time: float) -> Vector3:
	var bob_freq: float = global_bob_freq * global_bob_freq_modifier * vertical_bob_freq_modifier
	var bob_ampl: float = global_bob_ampl * global_bob_ampl_modifier * vertical_bob_ampl_modifier
	var y_axis: Vector3 = Vector3(0, 1, 0)
	var bob_offset: Vector3 = y_axis * sin(i_time * bob_freq) * bob_ampl
	return bob_offset

func bob_x(i_time: float) -> Vector3:
	var bob_freq: float = global_bob_freq * global_bob_freq_modifier * horizontal_bob_freq_modifier
	var bob_ampl: float = global_bob_ampl * global_bob_ampl_modifier * horizontal_bob_ampl_modifier
	var x_axis: Vector3 = Vector3(1, 0, 0)
	var bob_offset: Vector3 = x_axis * cos(i_time * bob_freq/2) * bob_ampl
	return bob_offset

func _editor_functions(delta: float) -> void:
	if Engine.is_editor_hint and _editor_preview_enabled:
		if enable_bob and node_target:
			bob(delta)
