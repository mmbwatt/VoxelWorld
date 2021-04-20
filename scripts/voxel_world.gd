extends Spatial

class_name VoxelWorld

export(Texture) var _texture_atlas

var chunk_dictionary = {}

func _ready():
	Helper.voxel_world_instance = self
	BuildWorld()


func BuildWorld() -> void:
	for z in Helper.world_size:
		for x in Helper.world_size:
			for y in Helper.column_height:
				var chunkPosition := Vector3(x * Helper.chunk_size,\
											 y * Helper.chunk_size,\
											 z * Helper.chunk_size)
				var chunk = Chunk.new(chunkPosition, _texture_atlas);
				chunk_dictionary[Helper.BuildChunkName(chunkPosition)] = chunk
		
	for chunk in chunk_dictionary:
		var temp = chunk_dictionary.get(chunk) as Chunk
		if temp:
			add_child(temp)
			temp.DrawChunk()
		yield(get_tree(), "idle_frame")
