extends Node

const chunk_size := 16
const column_height := 2
const world_size := 2

const max_height := 20

var noise: OpenSimplexNoise
#var voxel_world_instance
var chunk_dictionary: Dictionary

func _ready():
	SetUpNoise()


func BuildChunkName(position:Vector3) -> String:
	return str(position.x as int) + "_" + str(position.y as int) + "_" + str(position.z as int)


func TryGetChunk(name:String) -> Chunk:
	if chunk_dictionary.has(name):
		return chunk_dictionary.get(name)
	return null


func SetUpNoise() -> void:
	noise = OpenSimplexNoise.new()
	noise.seed = 0
	noise.octaves = 4
	noise.period = 20
	noise.persistence = 0.5


func GenerateHeight(x:float, z:float) -> int:
	var weight = inverse_lerp(-1, 1, noise.get_noise_2d(x, z))
	var height = lerp(0, max_height, weight)
	return height as int


