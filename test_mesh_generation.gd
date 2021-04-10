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
	verts.append(p4)
	verts.append(p5)
	verts.append(p1)
	verts.append(p0)
	
	normals.append(Vector3.FORWARD)
	normals.append(Vector3.FORWARD)
	normals.append(Vector3.FORWARD)
	normals.append(Vector3.FORWARD)
		
	uvs.append(uv11)
	uvs.append(uv01)
	uvs.append(uv00)
	uvs.append(uv10)
	
	#clockwise winding order in Godot
	indices.append_array(PoolIntArray([3,0,1,3,1,2]))
	
	arr[Mesh.ARRAY_VERTEX] = verts
	arr[Mesh.ARRAY_TEX_UV] = uvs
	arr[Mesh.ARRAY_NORMAL] = normals
	arr[Mesh.ARRAY_INDEX] = indices
	
	var mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr)
	
	mi.mesh = mesh
	
	add_child(mi)
