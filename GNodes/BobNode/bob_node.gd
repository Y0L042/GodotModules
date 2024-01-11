@tool
@icon('res://GodotModules/GNodes/BobNode/icons/icons8-infinity-100.png')
class_name BobNode
extends Node3D

@export_group("Node References")
var _node_target: Node3D
@export var node_target: Node3D:
	get:
		return _node_target
	set(value):
		if _node_target:
			_node_target.transform = _node_target_original_transform
		_node_target = value
		_node_target_original_transform = value.transform
		_node_target_original_position = value.position

#TODO Refactor these settings into a BobConfigResource
@export_group("Bob Config")
@export var enable_permanent_bob: bool = false
@export_subgroup("Global Bob")
@export var global_bob_freq: float = 1
@export var global_bob_ampl: float = 1
@export var global_bob_ampl_scale: float = 1
@export_subgroup("Vertical Bob")
@export var enable_vertical_bob: bool = true
@export var vertical_bob_freq_offset: float = 0
@export var vertical_bob_freq: float = 1
@export var vertical_bob_ampl: float = 1
@export_subgroup("Horizontal Bob")
@export var enable_horizontal_bob: bool = true
@export var horizontal_bob_freq_offset: float = 0
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
		if !Engine.is_editor_hint(): return
		if !enabled:
			node_target.transform = _node_target_original_transform

#region Modifiers
var global_bob_freq_modifier: float = 1
var global_bob_ampl_modifier: float = 1
var vertical_bob_freq_modifier: float = 1
var vertical_bob_ampl_modifier: float = 1
var horizontal_bob_freq_modifier: float = 1
var horizontal_bob_ampl_modifier: float = 1
#region Modifiers

var bob_enabled: bool = false
var _bob_rad_t: float = 0
var _node_target_original_position: Vector3

var _node_target_original_transform: Transform3D

func _ready() -> void:
	if node_target: _node_target_original_transform = node_target.transform
	if node_target: _node_target_original_position = node_target.position


func _physics_process(delta: float) -> void:
	_editor_functions(delta)
	# var tween: Tween = get_tree().create_tween()
	# tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	if !Engine.is_editor_hint():
		if enable_permanent_bob and node_target:
			_bob(delta)
		if bob_enabled and node_target:
			# tween.kill()
			_bob(delta)
			bob_enabled = false
			reset_modifiers()
		else:
			node_target.position = node_target.position.move_toward(_node_target_original_position, 2.5 * delta)
			# tween.tween_property(node_target, "position", _node_target_original_position, 2.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)

func play_bob() -> void:
	bob_enabled = true

func _bob(delta: float) -> void:
	_bob_rad_t += delta #wrap(_bob_rad_t + delta, 0, PI * 1000)
	var bob_offset: Vector3 = bob_x(_bob_rad_t) * float(enable_horizontal_bob) + bob_y(_bob_rad_t) * float(enable_vertical_bob)
	# node_target.transform.origin = _node_target_original_position + bob_offset
	node_target.position += bob_offset

func bob_y(i_delta: float) -> Vector3:
	var bob_freq: float = global_bob_freq * global_bob_freq_modifier * vertical_bob_freq * vertical_bob_freq_modifier
	var bob_ampl: float = global_bob_ampl * global_bob_ampl_modifier * vertical_bob_ampl * vertical_bob_ampl_modifier * global_bob_ampl_scale
	var y_axis: Vector3 = Vector3(0, 1, 0)
	var bob_offset: Vector3 = y_axis * sin(i_delta * bob_freq + vertical_bob_freq_offset) * bob_ampl
	return bob_offset

func bob_x(i_delta: float) -> Vector3:
	var bob_freq: float = global_bob_freq * global_bob_freq_modifier * horizontal_bob_freq * horizontal_bob_freq_modifier
	var bob_ampl: float = global_bob_ampl * global_bob_ampl_modifier * horizontal_bob_ampl * horizontal_bob_ampl_modifier * global_bob_ampl_scale
	var x_axis: Vector3 = Vector3(1, 0, 0)
	var bob_offset: Vector3 = x_axis * cos(i_delta * bob_freq/2 + horizontal_bob_freq_offset) * bob_ampl
	return bob_offset

func reset_modifiers() -> void:
	global_bob_freq_modifier = 1
	global_bob_ampl_modifier = 1
	vertical_bob_freq_modifier = 1
	vertical_bob_ampl_modifier = 1
	horizontal_bob_freq_modifier = 1
	horizontal_bob_ampl_modifier = 1

func _editor_functions(delta: float) -> void:
	if Engine.is_editor_hint() and _editor_preview_enabled:
		if node_target:
			_bob(delta)
