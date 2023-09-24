class_name MineChunk extends Node2D

@onready var tile_map: TileMap = $TileMap
@onready var resource_scene = preload("res://Scenes/resource.tscn")

func initialize_resources(parent: Node2D):
	print('initializing resources ', self)
	var resource_cells = tile_map.get_used_cells_by_id(2, -1, Vector2i(56,21))
	for cell in resource_cells:
		var resource_position: Vector2 = to_global(tile_map.map_to_local(cell))
		var resource_instance: MiningResource = resource_scene.instantiate()
		resource_instance.position = resource_position + Vector2(8,0)
		parent.add_child(resource_instance)
		tile_map.erase_cell(2, cell)
