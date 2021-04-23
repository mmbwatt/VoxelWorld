extends Spatial

class_name VoxelWorld

export(Texture) var _texture_atlas
export(NodePath) onready var _look_target = get_node(_look_target) as Spatial

const draw_radius := 4
var first_build := true
var building := false

func _ready():
	var target_global: Vector3 = _look_target.get_global_transform().origin
	BuildChunkAt((target_global.x/Helper.chunk_size) as int,
				 (target_global.y/Helper.chunk_size) as int,
				 (target_global.z/Helper.chunk_size) as int)
	
	DrawChunks()
	BuildRecursiveWorld((target_global.x/Helper.chunk_size) as int,
						(target_global.y/Helper.chunk_size) as int,
						(target_global.z/Helper.chunk_size) as int,
						draw_radius)


func BuildChunkAt(x: int, y: int, z: int) -> void:
	var chunkPosition := Vector3(x * Helper.chunk_size,
								 y * Helper.chunk_size,
								 z * Helper.chunk_size)
	var chunk_name := Helper.BuildChunkName(chunkPosition)
	var chunk := Helper.chunk_dictionary.get(chunk_name) as Chunk
	
	if chunk == null:
		chunk = Chunk.new(chunkPosition, _texture_atlas);
		Helper.AddToChunkDictionary(chunk_name, chunk)


func BuildWorld() -> void:
	building = true
	var target_global: Vector3 = _look_target.get_global_transform().origin
	var posx := floor(target_global.x/Helper.chunk_size) as int
	var posz := floor(target_global.z/Helper.chunk_size) as int
	
	var z := -draw_radius
	while z <= draw_radius:
		var x := -draw_radius
		while x <= draw_radius:
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
		


func BuildRecursiveWorld(x: int, y: int, z: int, rad: int) -> void:
	rad -= 1
	if rad <= 0:
		return
	
	#Build chunk front
	BuildChunkAt(x, y, z+1)
	BuildRecursiveWorld(x, y, z+1, rad)
	yield(get_tree(), "idle_frame")
	
	#Build chunk back
	BuildChunkAt(x, y, z-1)
	BuildRecursiveWorld(x, y, z-1, rad)
	yield(get_tree(), "idle_frame")
	
	#Build chunk right
	BuildChunkAt(x+1, y, z)
	BuildRecursiveWorld(x+1, y, z, rad)
	yield(get_tree(), "idle_frame")
	
	#Build chunk left
	BuildChunkAt(x-1, y, z)
	BuildRecursiveWorld(x-1, y, z, rad)
	yield(get_tree(), "idle_frame")
	
	#Build chunk above
	BuildChunkAt(x, y+1, z)
	BuildRecursiveWorld(x, y+1, z, rad)
	yield(get_tree(), "idle_frame")
	
	#Build chunk below
	BuildChunkAt(x, y-1, z)
	BuildRecursiveWorld(x, y-1, z, rad)
	yield(get_tree(), "idle_frame")


func DrawChunks() -> void:
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

