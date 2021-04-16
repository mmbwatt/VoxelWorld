extends Spatial

class_name Chunk

export var texture_image : Texture
var chunk_data = []
var chunkSize : int
var chunk_position

func _init(setPosition:Vector3, setTexture:Texture):
	self.translation = setPosition
	self.name = Helper.BuildChunkName(setPosition)
	texture_image = setTexture
	chunkSize = Helper.chunk_size
	buildChunk()


func buildChunk() -> void:
	#Create blocks
	chunk_data.resize(chunkSize)
	for x in chunkSize:
		chunk_data[x] = []
		chunk_data[x].resize(chunkSize)
		for y in chunkSize:
			chunk_data[x][y] = []
			chunk_data[x][y].resize(chunkSize)
			for z in chunkSize:
				var pos := Vector3(x,y,z)
				if rand_range(0, 100) <50:
					var block = Block.new(Enums.BlockType.DIRT, pos, self, texture_image)
					chunk_data[x][y][z] = block
				else:
					var block = Block.new(Enums.BlockType.AIR, pos, self, texture_image)
					chunk_data[x][y][z] = block
				
				


func DrawChunk() -> void:
	#Draw blocks
	for x in chunkSize:
		for y in chunkSize:
			for z in chunkSize:
				add_child(chunk_data[x][y][z])
				chunk_data[x][y][z].Draw()
	CombineQuads()


func CombineQuads() -> void:
	var temp_vertices = PoolVector3Array()
	var temp_uvs = PoolVector2Array()
	var temp_normals = PoolVector3Array()
	var temp_indices = PoolIntArray()
	
	var temp_position : Vector3
	
	var counter : int = 0
	var blocks_array = get_children()
	for block in blocks_array:
		if block is Block:
			temp_position = block.position
		var quads_array = block.get_children()
		for quad in quads_array:
			if quad is MeshInstance:
				var mesh = quad.get_mesh()
				var array = mesh.surface_get_arrays(0)
				for vertex in array[Mesh.ARRAY_VERTEX]:
					temp_vertices.append(vertex + temp_position)
				temp_normals.append_array(array[Mesh.ARRAY_NORMAL])
				temp_uvs.append_array(array[Mesh.ARRAY_TEX_UV])
				for index in array[Mesh.ARRAY_INDEX]:
					temp_indices.append(index + counter)
			counter += 4
	
	var mesh_array = []
	mesh_array.resize(Mesh.ARRAY_MAX)
	
	mesh_array[Mesh.ARRAY_VERTEX] = temp_vertices
	mesh_array[Mesh.ARRAY_NORMAL] = temp_normals
	mesh_array[Mesh.ARRAY_TEX_UV] = temp_uvs
	mesh_array[Mesh.ARRAY_INDEX] = temp_indices
	
	var mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_array)
	
	var material_one = SpatialMaterial.new()
	material_one.albedo_texture = texture_image
	
	var mesh_instance = MeshInstance.new()
	mesh_instance.mesh = mesh
	mesh_instance.set_surface_material(0, material_one)
	
	RemoveChildren()
	
	add_child(mesh_instance)


func RemoveChildren() -> void:
	for n in get_children():
		n.queue_free()
