@tool
class_name WaveGenerator
extends Node

var node_parent: Node
var noise_source: FastNoiseLite = FastNoiseLite.new()
var time_counter_int: int = 0

enum WaveShapes {
	SINE,
	RAND_PERLIN
}
	
func _physics_process(delta: float) -> void:
	time_counter_int += 1

func noise_wave(delta: float) -> float:
	var rand: float = noise_source.get_noise_1d(time_counter_int)
	return rand

static func spawn(i_node_parent: Node) -> WaveGenerator:
	var new_wave_gen: WaveGenerator = WaveGenerator.new()
	i_node_parent.add_child(new_wave_gen)
	new_wave_gen.owner = i_node_parent
	return new_wave_gen

