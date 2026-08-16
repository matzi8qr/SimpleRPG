class_name ShieldHero extends Hero2D


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
	shield_default_timer.connect("timeout", game._on_shield_timeout);
	add_child(shield_default_timer);
	

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
		var tile_is_clear = game.room.try_push_entity(coord, direction);  # returns true if the tile is blank for shield
		if tile_is_clear: game.room.set_cell("MiscTileLayer", coord, 0, game.SHIELD_ATLAS_TILE);
		
	shield_default_timer.start();  # NOTE, only do this in puzzle mode
