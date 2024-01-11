class_name CharacterBodyMovementComponent
extends Node3D

@export_group("References")
@export var movement_stats: MovementStatsResource
@export var character_body: CharacterBody3D

@export_group("Settings")
@export var MAX_STEP_SIZE: float = 0.5

var velocity_modifier_array: Array[Callable] = []

func _init() -> void:
	add_to_group("IComponent") #TODO make into something more reliable

func move(
			delta: float,
			i_character_body: CharacterBody3D,
			i_velocity: Vector3
		) -> void:
	i_velocity = apply_velocity_modifiers(i_velocity)
	i_character_body.velocity = i_velocity
	var is_colliding: bool = i_character_body.move_and_slide()
	if !is_colliding: return
	if i_character_body.get_last_slide_collision().get_normal().dot(Vector3.UP) < 0.707:
		step_check(delta, character_body, i_velocity)

func calculate_velocity(
			i_delta: float,
			i_character_body: CharacterBody3D,
			i_wish_direction: Vector3,
			i_wish_speed: float,
			i_acceleration: float,
		) -> Vector3:
	var wish_vel: Vector3 = i_wish_direction.normalized() * i_wish_speed
	var current_vel: Vector3 = i_character_body.get_real_velocity()
	var target_vel: Vector3 = current_vel.move_toward(wish_vel, i_acceleration * i_delta)
	return target_vel

func calculate_impulse(
			i_wish_direction: Vector3,
			i_impulse_force: float,
		) -> Vector3:
	var wish_impulse: Vector3 = i_wish_direction.normalized() * i_impulse_force
	var target_impulse: Vector3 = wish_impulse
	return target_impulse

func apply_velocity_modifiers(i_velocity: Vector3) -> Vector3:
	for modifier in velocity_modifier_array:
		i_velocity = modifier.call(i_velocity)
	velocity_modifier_array.clear()
	return i_velocity

func step_check(delta: float, i_character: CharacterBody3D, i_wish_vel: Vector3) -> bool:
	var character: CharacterBody3D = i_character
	var next_xz_pos: Vector3 = character.global_position + i_wish_vel * Vector3(1, 0, 1) * delta
	var step_highest_pos: Vector3 = next_xz_pos + MAX_STEP_SIZE * Vector3.UP
	var step_lowest_pos: Vector3 = next_xz_pos + MAX_STEP_SIZE * Vector3.DOWN
	var step_cast_results: IntersectRayResults = ShapeCastClass.do_raycast_point_to_point(
				character,
				step_highest_pos,
				step_lowest_pos,
				[character.get_rid()],
			)
	if step_cast_results.dict.is_empty(): return false
	var next_pos: Vector3 = step_cast_results.position
	character.global_position = next_pos
	return true