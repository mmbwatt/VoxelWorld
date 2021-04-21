extends Spatial

class_name VoxelWorld

export(Texture) var _texture_atlas
export(NodePath) onready var _look_target = get_node(_look_target) as Spatial

#var first_build := true
var building := false


func _ready():
	#BuildWorld()
	pass


func _process(_delta):
	if not building:
		BuildWorld()


func BuildWorld() -> void:
	building = true
	var target_global: Vector3 = _look_target.get_global_transform().origin
	var posx := floor(target_global.x/Helper.chunk_size) as int
	var posz := floor(target_global.z/Helper.chunk_size) as int
	
	var z := -Helper.draw_radius
	while z <= Helper.draw_radius:
		var x := -Helper.draw_radius
		while x <= Helper.draw_radius:
			for y in Helper.column_height:
				var chunkPosition := Vector3((posx + x) * Helper.chunk_size,\
											 y * Helper.chunk_size,\
											 (posz + z) * Helper.chunk_size)
				
				var chunk_name := Helper.BuildChunkName(chunkPosition)
				var chunk = Helper.chunk_dictionary.get(chunk_name) as Chunk
				if not chunk == null:
					chunk.chunk_status = Enums.ChunkStatus.KEEP
					break
				else:
					chunk = Chunk.new(chunkPosition, _texture_atlas);
					Helper.chunk_dictionary[chunk_name] = chunk
				yield(get_tree(), "idle_frame")
			x += 1
		z += 1
		
	for chunk in Helper.chunk_dictionary:
		var temp = Helper.chunk_dictionary.get(chunk) as Chunk
		if temp.chunk_status == Enums.ChunkStatus.DRAW:
			temp.chunk_status = Enums.ChunkStatus.KEEP
			add_child(temp)
			temp.DrawChunk()
		
		# will delete old chunks
		
		temp.chunk_status = Enums.ChunkStatus.DONE
		yield(get_tree(), "idle_frame")
		
	building = false

