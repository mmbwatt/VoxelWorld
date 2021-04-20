extends Spatial

class_name VoxelWorld

export(Texture) var _texture_atlas

var chunk_dictionary = {}

func _ready():
	BuildChunkColumn()


func BuildChunkColumn() -> void:
	for i in Helper.column_height:
		var chunkPosition := Vector3(self.translation.x,\
									 i * Helper.chunk_size,\
									 self.translation.z)
		var chunk = Chunk.new(chunkPosition, _texture_atlas);
		chunk_dictionary[Helper.BuildChunkName(chunkPosition)] = chunk
		
	for chunk in chunk_dictionary:
		var temp = chunk_dictionary.get(chunk) as Chunk
		if temp:
			add_child(temp)
			temp.DrawChunk()
		yield(get_tree(), "idle_frame")
