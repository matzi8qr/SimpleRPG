# set up a custom Hero class for all of our characters to use
class_name Hero2D extends Sprite2D


@onready var room: Room2D = get_parent().get_parent();  # holy jank
@onready var game: Game2D = room.get_parent(); 			# it continues
@onready var entity_map: TileMapLayer = room.get_entity_map()
@onready var room_map: TileMapLayer = room.get_room_map();

@onready var cur_coords: Vector2i = room_map.local_to_map(position);
@onready var cur_tile: TileData = room_map.get_cell_tile_data(cur_coords);


# handles ability. toggled with 'E' or 'Enter', directionally fired with movement ability
func use_ability(_dest_coords: Vector2i, _dest_tile: TileData):
	# to be overriden by each hero
	pass
	

# move hero to destination tile
func move_to_tile(dest_coords: Vector2i, dest_tile: TileData) -> void:
	position = room_map.map_to_local(dest_coords);
	cur_coords = dest_coords;
	cur_tile = dest_tile;
