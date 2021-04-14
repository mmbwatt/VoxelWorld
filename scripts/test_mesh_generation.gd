extends Node

export var _texture_image : Texture

#All possible UVs
var uv00 := Vector2(0.1250,0.0000)
var uv01 := Vector2(0.1250,0.0625)
var uv10 := Vector2(0.1875,0.0000)
var uv11 := Vector2(0.1875,0.0625)
	
#All possible vertices
var p0 := Vector3(-0.5, -0.5,  0.5)
var p1 := Vector3( 0.5, -0.5,  0.5)
var p2 := Vector3( 0.5, -0.5, -0.5)
var p3 := Vector3(-0.5, -0.5, -0.5)
var p4 := Vector3(-0.5,  0.5,  0.5)
var p5 := Vector3( 0.5,  0.5,  0.5)
var p6 := Vector3( 0.5,  0.5, -0.5)
var p7 := Vector3(-0.5,  0.5, -0.5)
	
func _ready():
	CreateCube()

func CreateCube() -> void:
	CreateQuad(Enums.Cubeside.FRONT)
	CreateQuad(Enums.Cubeside.BACK)
	CreateQuad(Enums.Cubeside.TOP)
	CreateQuad(Enums.Cubeside.BOTTOM)
	CreateQuad(Enums.Cubeside.LEFT)
	CreateQuad(Enums.Cubeside.RIGHT)
	

func CreateQuad(side) -> void:
	var mi = MeshInstance.new()
	var arr = []
	arr.resize(Mesh.ARRAY_MAX)
	
	#PoolVectorXXArrays for each mesh construction.
	var verts = PoolVector3Array()
	var uvs = PoolVector2Array()
	var normals = PoolVector3Array()
	var indices = PoolIntArray()

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
	
	var material_one = SpatialMaterial.new()
	material_one.albedo_texture = _texture_image
	
	mi.mesh = mesh
	mi.set_surface_material(0, material_one)
	
	add_child(mi)

