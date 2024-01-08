@tool
@icon("res://GodotModules/GNodes/AudioStreamPlayerExtended/icons/AudioStreamPlayer3D.svg")
class_name AudioStreamPlayerExtended
extends AudioStreamPlayer3D

@export_group("Internal References")
@export var audio_package: AudioPackageResource
@export var gap_timer: Timer

@export_group("Editor Preview Settings")
@export var preview_sounds: bool = false

var player_name: String
var streams_array: Array[AudioStream]

func _ready() -> void:
	player_name = audio_package.package_name
	streams_array = audio_package.package_streams
	if player_name != "":
		name = player_name

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if preview_sounds:
			play_random_sound()
		else:
			stream = null

func play_random_sound() -> void:
	if playing: return
	stream = streams_array[_select_random_index(audio_package.package_streams)]
	play()

func play_random_sound_manual() -> void:
	stream = streams_array[_select_random_index(audio_package.package_streams)]
	play()

func DEP_play_random_sound_advanced(i_gap_time: float) -> void:
	if gap_timer.time_left > 0: return
	gap_timer.start(i_gap_time)
	stream = streams_array[_select_random_index(audio_package.package_streams)]
	play()

func play_random_sound_advanced(i_gap_time: float) -> void:
	if !playing:
		play_random_sound_manual()
	await get_tree().create_timer(i_gap_time).timeout
	play_random_sound_manual()


func _select_random_index(i_array: Array) -> int:
	return randi_range(0, len(i_array) - 1)
