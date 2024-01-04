class_name CharacterBodyMovementComponent
extends Node3D

@export var movement_stats: MovementStatsResource

var velocity_modifier_array: Array[Callable] = []

func _init() -> void:
	add_to_group("IComponent") #TODO make into something more reliable

func move(
			i_character_body: CharacterBody3D,
			i_velocity: Vector3
		) -> void:
	i_velocity = apply_velocity_modifiers(i_velocity)
	i_character_body.velocity = i_velocity
	i_character_body.move_and_slide()

func calculate_velocity(
			i_delta: float,
			i_character_body: CharacterBody3D,
			i_wish_direction: Vector3,
			i_wish_speed: float,
			i_acceleration: float,
		) -> Vector3:
	var wish_vel: Vector3 = i_wish_direction * i_wish_speed
	var current_vel: Vector3 = i_character_body.get_real_velocity()
	var target_vel: Vector3 = current_vel.move_toward(wish_vel, i_acceleration * i_delta)
	return target_vel

func apply_velocity_modifiers(i_velocity: Vector3) -> Vector3:
	for modifier in velocity_modifier_array:
		i_velocity = modifier.call(i_velocity)
	velocity_modifier_array.clear()
	return i_velocity