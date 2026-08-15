class_name ShieldHero extends Hero2D

const SHIELD_ATLAS_TILE = Vector2i(28, 12);

var shield_tiles: Array[Vector2i];
var shield_default_timer: Timer;

func _ready() -> void:
	super._ready();
	game.selected_hero = self;  # default select shield hero
	_setup_shield_timer();
	
	
# setup shield timeout for fade out
func _setup_shield_timer():
	shield_default_timer = Timer.new();
	shield_default_timer.wait_time = 0.86;
	shield_default_timer.one_shot = true;
	shield_default_timer.autostart = true;
	shield_default_timer.connect("timeout", _on_shield_timeout);
	add_child(shield_default_timer);


# delete shields in array and clear queue
func _on_shield_timeout():
	# TODO lighting/saturation fade out?
	for coords in shield_tiles:
		if misc_map.get_cell_atlas_coords(coords) == SHIELD_ATLAS_TILE:
			misc_map.set_cell(coords, -1)
		
	shield_tiles.clear()


# shield bash ability. effects in a 3 by 1 area adjacent and diagonally adjacant
# pushes pushable entities and enemies 1 block back and stuns their action
# also sets up shield on affected tiles that blocks projectiles for a turn
func use_ability(dest_coords: Vector2i) -> void:
	var direction: Vector2i = dest_coords - cur_coords;
	
	# get tile coords to place the temporary shield tile
	shield_tiles.append(dest_coords)
	if direction.x == 0:    # on up/down, hit left/right diagonals
		shield_tiles.append(dest_coords + Vector2i.LEFT);
		shield_tiles.append(dest_coords + Vector2i.RIGHT);
	elif direction.y == 0:  # on left/right, hit up/down diagonals
		shield_tiles.append(dest_coords + Vector2i.UP);
		shield_tiles.append(dest_coords + Vector2i.DOWN);
	
	for coord in shield_tiles:  # attempt to shield bash each entity by pushing it towards direction
		var tile_is_clear = room.try_push_entity(coord, direction);  # returns true if the tile is blank for shield
		if tile_is_clear: misc_map.set_cell(coord, 0, SHIELD_ATLAS_TILE);
		
	shield_default_timer.start();  # NOTE, only do this in puzzle mode
