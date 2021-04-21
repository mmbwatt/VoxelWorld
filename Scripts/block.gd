extends Node

class_name Block

var block_type
var is_solid : bool
var position : Vector3
var parent_chunk
var _texture_image : Texture

var blockUVs := [
	#Grass Top
	[Vector2(0.1250, 0.5625),Vector2(0.1875, 0.5625), 
	 Vector2(0.1250, 0.6250),Vector2(0.1875, 0.6250)],
	#Grass Side
	[Vector2(0.1875, 0.0000), Vector2(0.2500, 0.0000),
	 Vector2(0.1875, 0.0625), Vector2(0.2500, 0.0625)],
	#Dirt
	[Vector2(0.1250, 0.0000), Vector2(0.1875, 0.0000),
	 Vector2(0.1250, 0.0625), Vector2(0.1875, 0.0625)],
	#Stone
	[Vector2(0.0000, 0.0625), Vector2(0.0625, 0.0625),
	 Vector2(0.0000, 0.1250), Vector2(0.0625, 0.1250)],
	#Gold
	[Vector2(0.0000, 0.1250), Vector2(0.0625, 0.1250),
	 Vector2(0.0000, 0.1875), Vector2(0.0625, 0.1875)],
	#Bedrock
	[Vector2(0.3125, 0.1250), Vector2(0.3750, 0.1250),
	 Vector2(0.3125, 0.1875), Vector2(0.3750, 0.1875)]
]

func _init(setBlockType, setPosition:Vector3, setParent, setImage:Texture):
	block_type = setBlockType
	position = setPosition
	parent_chunk = setParent
	_texture_image = setImage
	if block_type == Enums.BlockType.AIR:
		is_solid = false
	else:
		is_solid = true
	
func CreateQuad(side) -> void:
	var arr = []
	arr.resize(Mesh.ARRAY_MAX)
	
	#PoolVectorXXArrays for each mesh construction.
	var verts = PoolVector3Array()
	var uvs = PoolVector2Array()
	var normals = PoolVector3Array()
	var indices = PoolIntArray()
	
	#All possible UVs
	var uv00 : Vector2
	var uv01 : Vector2
	var uv10 : Vector2
	var uv11 : Vector2
	
	var uvArray
	
	if block_type == Enums.BlockType.GRASS and side == Enums.Cubeside.TOP:
		uvArray = blockUVs[block_type]
	elif block_type == Enums.BlockType.GRASS and side == Enums.Cubeside.BOTTOM:
		uvArray = blockUVs[Enums.BlockType.DIRT + 1]
	else:
		uvArray = blockUVs[block_type + 1]
	
	#if not uvArray.empty():
	uv00 = uvArray[0]
	uv10 = uvArray[1]
	uv01 = uvArray[2]
	uv11 = uvArray[3]
		
	#All possible vertices
	var p0 := Vector3(-0.5, -0.5,  0.5)
	var p1 := Vector3( 0.5, -0.5,  0.5)
	var p2 := Vector3( 0.5, -0.5, -0.5)
	var p3 := Vector3(-0.5, -0.5, -0.5)
	var p4 := Vector3(-0.5,  0.5,  0.5)
	var p5 := Vector3( 0.5,  0.5,  0.5)
	var p6 := Vector3( 0.5,  0.5, -0.5)
	var p7 := Vector3(-0.5,  0.5, -0.5)
	
	match side:
		Enums.Cubeside.BOTTOM:
			verts.append_array(PoolVector3Array([p0, p1, p2, p3]))
			normals.append_array(PoolVector3Array([Vector3.DOWN,Vector3.DOWN,Vector3.DOWN,Vector3.DOWN]))
			uvs.append_array(PoolVector2Array([uv00, uv10, uv11, uv01]))
			indices.append_array(PoolIntArray([3,0,1,3,1,2]))
		Enums.Cubeside.TOP:
			verts.append_array(PoolVector3Array([p4, p5, p6, p7]))
			normals.append_array(PoolVector3Array([Vector3.UP,Vector3.UP,Vector3.UP,Vector3.UP]))
			uvs.append_array(PoolVector2Array([uv00, uv10, uv11, uv01]))
			indices.append_array(PoolIntArray([3,1,0,3,2,1]))
		Enums.Cubeside.FRONT:
			verts.append_array(PoolVector3Array([p4, p5, p1, p0]))
			normals.append_array(PoolVector3Array([Vector3.FORWARD,Vector3.FORWARD,Vector3.FORWARD,Vector3.FORWARD]))
			uvs.append_array(PoolVector2Array([uv00, uv10, uv11, uv01]))
			indices.append_array(PoolIntArray([3,0,1,3,1,2]))
		Enums.Cubeside.BACK:
			verts.append_array(PoolVector3Array([p7, p6, p2, p3]))
			normals.append_array(PoolVector3Array([Vector3.BACK,Vector3.BACK,Vector3.BACK,Vector3.BACK]))
			uvs.append_array(PoolVector2Array([uv00, uv10, uv11, uv01]))
			indices.append_array(PoolIntArray([3,1,0,3,2,1]))
		Enums.Cubeside.LEFT:
			verts.append_array(PoolVector3Array([p7, p4, p0, p3]))
			normals.append_array(PoolVector3Array([Vector3.LEFT,Vector3.LEFT,Vector3.LEFT,Vector3.LEFT]))
			uvs.append_array(PoolVector2Array([uv00, uv10, uv11, uv01]))
			indices.append_array(PoolIntArray([3,0,1,3,1,2]))
		Enums.Cubeside.RIGHT:
			verts.append_array(PoolVector3Array([p5, p6, p2, p1]))
			normals.append_array(PoolVector3Array([Vector3.RIGHT,Vector3.RIGHT,Vector3.RIGHT,Vector3.RIGHT]))
			uvs.append_array(PoolVector2Array([uv00, uv10, uv11, uv01]))
			indices.append_array(PoolIntArray([3,0,1,3,1,2]))
	
	arr[Mesh.ARRAY_VERTEX] = verts
	arr[Mesh.ARRAY_TEX_UV] = uvs
	arr[Mesh.ARRAY_NORMAL] = normals
	#clockwise winding order in Godot
	arr[Mesh.ARRAY_INDEX] = indices
	
	var mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr)
	
	var mi = MeshInstance.new()
	mi.mesh = mesh
	add_child(mi)


func HasSolidNeighbour(x:int, y:int, z:int) -> bool:
	var chunks = parent_chunk.GetChunkData()
	var neighbour_name: String
	var neighbour_chunk
	
	if x < 0 or x >= Helper.chunk_size or\
	   y < 0 or y >= Helper.chunk_size or\
	   z < 0 or z >= Helper.chunk_size:
		var neighbour_chunk_position := Vector3((x - position.x as int) * Helper.chunk_size,\
										   (y - position.y as int) * Helper.chunk_size,\
										   (z - position.z as int) * Helper.chunk_size)
		neighbour_chunk_position += parent_chunk.translation
		neighbour_name = Helper.BuildChunkName(neighbour_chunk_position)
		
		x = ConvertBlockIndexToLocal(x)
		y = ConvertBlockIndexToLocal(y)
		z = ConvertBlockIndexToLocal(z)
		
		neighbour_chunk = Helper.chunk_dictionary.get(neighbour_name)
		if not neighbour_chunk == null:
			chunks = neighbour_chunk.GetChunkData()
		else:
			return false
	
	if chunks[x][y][z]:
		return chunks[x][y][z].IsSolid()
				
	return false


func Draw() -> void:
	if block_type == Enums.BlockType.AIR:
		return
	
	if not HasSolidNeighbour(position.x as int, position.y as int, (position.z + 1) as int):
		CreateQuad(Enums.Cubeside.FRONT)
	if not HasSolidNeighbour(position.x as int, position.y as int, (position.z - 1) as int):
		CreateQuad(Enums.Cubeside.BACK)
	if not HasSolidNeighbour(position.x as int, (position.y + 1) as int, position.z as int):
		CreateQuad(Enums.Cubeside.TOP)
	if not HasSolidNeighbour(position.x as int, (position.y - 1) as int, position.z as int):
		CreateQuad(Enums.Cubeside.BOTTOM)
	if not HasSolidNeighbour((position.x + 1) as int, position.y as int, position.z as int):
		CreateQuad(Enums.Cubeside.RIGHT)
	if not HasSolidNeighbour((position.x - 1) as int, position.y as int, position.z as int):
		CreateQuad(Enums.Cubeside.LEFT)


func IsSolid() -> bool:
	return is_solid


func ConvertBlockIndexToLocal(index:int) -> int:
	var i := index
	if index == -1:
		i = Helper.chunk_size - 1
	elif index == Helper.chunk_size:
		i = 0
	return i


func RemoveMeshes() -> void:
	for child in get_children():
		if child is MeshInstance:
			child.queue_free()
