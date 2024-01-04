class_name MovementStatsResource
extends Resource

@export_group("Movement Values")

@export_subgroup("Ground Movement")
@export_range(0, 10, 0.1) var ground_walk_speed: float = 5
@export_range(0, 20, 0.1) var ground_run_speed: float = 7.5
@export_range(0, 45, 0.1) var ground_sprint_speed: float = 12.5
@export_range(0, 100, 0.1) var ground_acceleration: float = 45
@export_range(0, 100, 0.1) var ground_friction: float = 35

@export_subgroup("Air Movement")
@export_range(0, 20, 0.1) var air_move_speed: float = 7
@export_range(0, 100, 0.1) var air_acceleration: float = 20
@export_range(0, 100, 0.1) var air_friction: float = 15
@export_range(0, 5, 0.1) var gravity_modifier: float = 1