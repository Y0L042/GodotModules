class_name IntersectRayResults

var positive_results: bool
var collider: Variant
var collider_id: Variant
var normal: Vector3
var position: Vector3
var face_index: int
var rid: Variant
var shape: Variant

func _init(i_results_dict: Dictionary) -> void:
	if i_results_dict.is_empty():
		positive_results = false
		return
	positive_results = true
	collider = i_results_dict.collider
	collider_id = i_results_dict.collider_id
	normal = i_results_dict.normal
	position = i_results_dict.position
	face_index = i_results_dict.index
	rid = i_results_dict.rid
	shape = i_results_dict.shape