class_name AudioPlayerComponent
extends Node

@export var gap_timer: Timer

var audiostreamplayer_extended_array: Array[AudioStreamPlayerExtended] = []

func _ready() -> void:
	for child in get_children():
		audiostreamplayer_extended_array.append(child)

func play_sounds(i_player_name: String) -> void:
	_find_audiostreamplayer_extended(i_player_name).play_random_sound()

func play_sounds_advanced(i_player_name: String, i_gap_time: float) -> void:
	_find_audiostreamplayer_extended(i_player_name).play_random_sound_advanced(i_gap_time)

func _find_audiostreamplayer_extended(i_player_name: String) -> AudioStreamPlayerExtended:
	for player in audiostreamplayer_extended_array:
		if player.name == i_player_name:
			return player
	return null
