extends Node

const chunk_size := 8
const column_height := 4
const world_size := 4

var voxel_world_instance

func BuildChunkName(position: Vector3) -> String:
	return str(position.x as int) + "_" + str(position.y as int) + "_" + str(position.z as int)


func TryGetChunk(name:String):
	if voxel_world_instance is VoxelWorld:
		if voxel_world_instance.chunk_dictionary.has(name):
			return voxel_world_instance.chunk_dictionary[name]
	return null
