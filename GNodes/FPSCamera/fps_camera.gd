@icon("./icons/icons8-gopro-100.png")
class_name FPSCamera
extends Marker3D

@export_group("Node References")
@export_subgroup("External References")
@export var node_root: Node
@export var rot_target_y: Node3D
@export var rot_target_x: Node3D
@export_subgroup("Internal References")
@export var main_camera: Camera3D
@export var subview_camera: Camera3D
@export var subview_root: Marker3D

@export_group("Config Settings TODO")
@export_range(1, 100, 5) var MOUSE_SENSITIVITY: float = 50
@export var LOOK_DOWN_CLAMP_DEG: float = 89
@export var LOOK_UP_CLAMP_DEG: float = 89

@export_group("Headbob Config")
@export var enable_camera_bob: bool = false
@export var default_bob_freq: float = 1
@export var default_bob_ampl: float = 0.1

var bob_freq_modifier: float = 1
var bob_ampl_modifier: float = 1
var bob_rad_t: float = 0

func _physics_process(_delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	handle_mouse_look(event)

func handle_mouse_look(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var sensitivity: float = MOUSE_SENSITIVITY / 500
		# 1. First rotate Y
		rot_target_y.rotate_y(deg_to_rad(-event.relative.x * sensitivity))
		# 2. Second rotate X
		rot_target_x.rotate_x(deg_to_rad(-event.relative.y * sensitivity)) # we only tilt the camera up and down
		rot_target_x.rotation.x = clamp(rot_target_x.rotation.x, deg_to_rad(-LOOK_DOWN_CLAMP_DEG), deg_to_rad(LOOK_UP_CLAMP_DEG))

func headbob(delta: float) -> void:
	if !enable_camera_bob: return
	y_headbob(delta)

func y_headbob(delta: float) -> void:
	bob_rad_t = wrap(bob_rad_t + delta, 0, PI)
	var current_hpos: Vector3 = Vector3(1, 0, 1) * transform.origin
	var bob_offset: Vector3 = Vector3(0, 1, 0) * sin(bob_rad_t * default_bob_freq * bob_freq_modifier) * default_bob_ampl
	transform.origin = current_hpos + bob_offset
