extends Node

const chunk_size := 10
const column_height := 5

var max_height: int
var dirt_noise: OpenSimplexNoise
var stone_noise: OpenSimplexNoise
var cave_noise: OpenSimplexNoise
var gold_noise: OpenSimplexNoise
var chunk_dictionary: Dictionary
var mutex: Mutex

func _ready():
	mutex = Mutex.new()
	max_height = chunk_size * column_height
	SetUpNoise()


func BuildChunkName(position: Vector3) -> String:
	return str(position.x as int) + "_" + str(position.y as int) + "_" + str(position.z as int)


func TryGetChunk(name: String) -> Chunk:
	if chunk_dictionary.has(name):
		return chunk_dictionary.get(name)
	return null


func SetUpNoise(noiseSeed: int = 0) -> void:
	dirt_noise = OpenSimplexNoise.new()
	dirt_noise.seed = noiseSeed
	dirt_noise.period = 70
	
	stone_noise = OpenSimplexNoise.new()
	stone_noise.seed = noiseSeed
	stone_noise.period = 64
	
	cave_noise = OpenSimplexNoise.new()
	cave_noise.seed = noiseSeed
	cave_noise.period = 13
	
	gold_noise = OpenSimplexNoise.new()
	gold_noise.seed = noiseSeed
	cave_noise.period = 10


func GenerateDirtHeight(x: float, z: float) -> int:
	var dirt_max_height := max_height * 0.65
	var weight := inverse_lerp(-1, 1, dirt_noise.get_noise_2d(x, z))
	var height = lerp(0, dirt_max_height, weight)
	return height as int


func GenerateStoneHeight(x: float, z: float) -> int:
	var stone_max_height := max_height * 0.5
	var weight = inverse_lerp(-1, 1, stone_noise.get_noise_2d(x, z))
	var height = lerp(0, stone_max_height, weight)
	return height as int


func GetCaveProbability(x: float, y: float, z: float) -> float:
	var weight = inverse_lerp(-1, 1, cave_noise.get_noise_3d(x, y, z))
	return lerp (0, 1, weight)


func GetGoldProbability(x: float, y: float, z: float) -> float:
	var weight = inverse_lerp(-1, 1, gold_noise.get_noise_3d(x, y, z))
	return lerp (0, 1, weight)

func AddToChunkDictionary(name: String, chunk):
	mutex.lock()
	chunk_dictionary[name] = chunk
	mutex.unlock()
