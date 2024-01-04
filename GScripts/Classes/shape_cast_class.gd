class_name ShapeCastClass

func do_raycast_point_to_point(
            i_context: Object,
            i_origin: Vector3, 
            i_target: Vector3, 
            i_rid_exeptions: Array[RID] = [], 
            i_col_mask: int = 0xFFFFFFFF
        ) -> IntersectRayResults:
    var space_state: PhysicsDirectSpaceState3D = i_context.get_tree().get_root().get_world_3d().direct_space_state
    var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(i_origin, i_target)
    if i_rid_exeptions:
        query.exclude = i_rid_exeptions
    query.collision_mask = i_col_mask
    var results_dict: Dictionary = space_state.intersect_ray(query)
    var result: IntersectRayResults = IntersectRayResults.new(results_dict)
    return result

# func do_shapecast_point_to_point(
#             i_context: Object,
#             i_origin: Vector3, 
#             i_target: Vector3, 
#             i_rid_exeptions: Array[RID] = [], 
#             i_col_mask: int = 0xFFFFFFFF
#         ) -> IntersectRayResults:
#     var space_state: PhysicsDirectSpaceState3D = i_context.get_tree().get_root().get_world_3d().direct_space_state
#     var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(i_origin, i_target)
#     if i_rid_exeptions:
#         query.exclude = i_rid_exeptions
#     query.collision_mask = i_col_mask
#     var results_dict: Dictionary = space_state.intersect_ray(query)
#     var result: IntersectRayResults = IntersectRayResults.new(results_dict)
#     return result