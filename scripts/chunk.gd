extends Spatial

export var cubeMaterial : Texture

func _ready():
	buildChunk(2,2,2)

func buildChunk(sizeX, sizeY, sizeZ) -> void:
	for x in sizeX:
		for y in sizeY:
			for z in sizeZ:
				var pos := Vector3(x,y,z)
				var block = Block.new(Enums.BlockType.DIRT, pos, cubeMaterial)
				add_child(block)
				block.Draw()
				#create block at pos
				#draw block at pos
				
