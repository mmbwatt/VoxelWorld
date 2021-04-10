extends Node

func _ready():
	CreateQuad()


func CreateQuad() -> void:
	var mi = MeshInstance.new()
	var arr = []
	arr.resize(Mesh.ARRAY_MAX)
	
	#PoolVectorXXArrays for each mesh construction.
	var verts = PoolVector3Array()
	var uvs= PoolVector2Array()
	var normals = PoolVector3Array()
	var indices = PoolIntArray()
	
	#All possible UVs
	var uv00: Vector2 = Vector2(0,0)
	var uv01: Vector2 = Vector2(0,1)
	var uv10: Vector2 = Vector2(1,0)
	var uv11: Vector2 = Vector2(1,1)
	
	#All possible vertices
	var p0: Vector3 = Vector3(-0.5, -0.5,  0.5)
	var p1: Vector3 = Vector3( 0.5, -0.5,  0.5)
	var p2: Vector3 = Vector3( 0.5, -0.5, -0.5)
	var p3: Vector3 = Vector3(-0.5, -0.5, -0.5)
	var p4: Vector3 = Vector3(-0.5,  0.5,  0.5)
	var p5: Vector3 = Vector3( 0.5,  0.5,  0.5)
	var p6: Vector3 = Vector3( 0.5,  0.5, -0.5)
	var p7: Vector3 = Vector3(-0.5,  0.5, -0.5)

	#Still need code for generating quad
	
	arr[Mesh.ARRAY_VERTEX] = verts
	arr[Mesh.ARRAY_TEX_UV] = uvs
	arr[Mesh.ARRAY_NORMAL] = normals
	arr[Mesh.ARRAY_INDEX] = indices
	
	var mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr)
	
