class_name CharacterBodyMovementComponent
extends Node3D

@export_group("References")
@export var movement_stats: MovementStatsResource
@export var character_body: CharacterBody3D
@export var stairs_ray: RayCast3D

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
	if step_check(delta, i_character_body, i_velocity): 
		i_character_body.velocity = Vector3.ZERO
		return
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

func step_check(delta: float, i_character: CharacterBody3D, i_vel: Vector3) -> bool:
	GDebug.panel.add_property("StairsRayIsColliding", stairs_ray.is_colliding())
	if stairs_ray.is_colliding():
		var collision_point: Vector3 = stairs_ray.get_collision_point()
		var result: PhysicsTestMotionResult3D = bodycast_to_point(i_character, i_character.global_position, collision_point)
		var target_point: Vector3
		if result:
			target_point = result.get_collision_point()
		else:
			target_point = collision_point
		# target_point = i_character.global_position + i_character.global_position.direction_to(target_point) * i_vel.length() * 0.75
		i_character.global_position = target_point
		return true
	return false


func bodycast_to_point(i_body: PhysicsBody3D, i_from: Vector3, i_to: Vector3) -> PhysicsTestMotionResult3D:
	var from_xform: Transform3D = i_body.transform
	from_xform.origin = i_from
	var motion: Vector3 = i_to - i_from
	var parameters: PhysicsTestMotionParameters3D = PhysicsTestMotionParameters3D.new()
	var result: PhysicsTestMotionResult3D = PhysicsTestMotionResult3D.new()
	parameters.from = from_xform
	parameters.motion = motion
	var has_collided: bool = PhysicsServer3D.body_test_motion(i_body.get_rid(), parameters, result)
	if has_collided:
		return result
	else: 
		return null