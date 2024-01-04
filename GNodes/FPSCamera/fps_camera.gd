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
@export var MOUSE_SENSITIVITY: float = 50
@export var LOOK_DOWN_CLAMP_DEG: float = 89
@export var LOOK_UP_CLAMP_DEG: float = 89

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
