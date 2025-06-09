extends TileMapLayer

var tilemap

func _ready() -> void:
	tilemap = get_parent().get_child(0)

func _process(delta: float) -> void:
	var current_tile = local_to_map(get_global_mouse_position())
	for x in 16:
		for y in 10:
			erase_cell(Vector2i(x,y))
	var tileData = tilemap.get_cell_tile_data(current_tile)
	if tileData:
		
		if tileData.get_custom_data("placeable"):
			set_cell(current_tile,1,Vector2i(1,1),0)
		else:
			set_cell(current_tile,1,Vector2i(0,0),0)
	
