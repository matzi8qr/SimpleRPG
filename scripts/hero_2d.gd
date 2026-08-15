# set up a custom Hero class for all of our characters to use
class_name Hero2D extends Entity2D


@onready var room: Room2D = get_parent().get_parent();  # holy jank
@onready var game: Game2D = room.get_parent(); 			# it continues
@onready var entity_map: TileMapLayer = room.get_entity_map();
@onready var misc_map: TileMapLayer = room.get_misc_map();
@onready var room_map: TileMapLayer = room.get_room_map();

@onready var cur_tile: TileData = room_map.get_cell_tile_data(cur_coords);


func _ready() -> void:
	# send self up to game to add to hero party
	game.hero_party.append(self);


# handles ability. toggled with 'E' or 'Enter', directionally fired with movement ability
func use_ability(_dest_coords: Vector2i) -> void:
	# to be overriden by each hero
	pass
	
