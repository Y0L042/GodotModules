class_name CharacterBodyMovementComponent
extends Node3D

@export_group("References")
@export var player: PlayerEntity
@export var movement_stats: MovementStatsResource
@export var character_body: CharacterBody3D
@export var stairs_ray: RayCast3D

@export_group("Settings")
@export var MAX_STEP_SIZE: float = 0.5

var velocity_modifier_array: Array[Callable] = []
var _was_last_frame_stairstepped: bool

func _init() -> void:
	add_to_group("IComponent") #TODO make into something more reliable

func move(
			delta: float,
			i_character_body: CharacterBody3D,
			i_velocity: Vector3
		) -> void:
	i_velocity = apply_velocity_modifiers(i_velocity)
	var vel_backup: Vector3 = i_velocity
	if _was_last_frame_stairstepped:
		i_velocity = Vector3.ZERO
	if player.input_flag_is_moving and attempt_stair_step(delta, i_character_body, i_velocity):
		i_character_body.velocity = Vector3.ZERO
		return
	if player.input_flag_jump: 
		_was_last_frame_stairstepped = false
		i_velocity = vel_backup
	i_character_body.velocity = i_velocity
	i_character_body.move_and_slide()

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

func attempt_stair_step(delta: float, i_character: CharacterBody3D, i_vel: Vector3) -> bool:
	_was_last_frame_stairstepped = false
	if stairs_ray.is_colliding():
		var collision_point: Vector3 = stairs_ray.get_collision_point()
		var motion: Vector3 = collision_point - i_character.global_position
		var result: PhysicsTestMotionResult3D = bodycast_to_point(i_character, motion)
		var target_point: Vector3
		if result:
			target_point = result.get_collision_point()
		else:
			target_point = collision_point
		i_character.global_position = target_point
		_was_last_frame_stairstepped = true
		return true
	return false

func bodycast_to_point(i_body: PhysicsBody3D, i_motion: Vector3) -> PhysicsTestMotionResult3D:
	var from_xform: Transform3D = i_body.transform
	var parameters: PhysicsTestMotionParameters3D = PhysicsTestMotionParameters3D.new()
	var result: PhysicsTestMotionResult3D = PhysicsTestMotionResult3D.new()
	parameters.from = from_xform
	parameters.motion = i_motion
	var has_collided: bool = PhysicsServer3D.body_test_motion(i_body.get_rid(), parameters, result)
	if has_collided:
		return result
	else:
		return null
