extends Node


func BuildChunkName(position: Vector3) -> String:
	return str(position.x) + "_" + str(position.y) + "_" + str(position.z)

const chunk_size := 8
const column_height := 8
