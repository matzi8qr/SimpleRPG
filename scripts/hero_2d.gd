# set up a custom Hero class for all of our characters to use
class_name Hero2D extends Sprite2D


@onready var room: Room2D = get_parent().get_parent();  # holy jank
@onready var entity_map: TileMapLayer = room.get_entity_map()
@onready var room_map: TileMapLayer = room.get_room_map();
@onready var cur_coords: Vector2i = room_map.local_to_map(position);
@onready var cur_tile: TileData = room_map.get_cell_tile_data(cur_coords);

var is_controlled: bool;
var is_ability_toggled: bool;

func _input(event):
	if not is_controlled: return;
	
	if event is InputEventMouse: return;   # this game ignores mouse inputs
	if event is InputEventKey:
		if event.is_echo(): return;		   # and ignores key hold inputs
		if not event.is_pressed(): return; # and ignores key release inputs
		# TODO ignore all other key presses too, save Space (pass) and esc (menu)
	
	# TODO buffer inputs against the turn-based system (and shifting control)
	# turn action economy goes as either move/interact or action
	
	# check for ability toggle first, and return - do not process movement and use action
	if event.is_action_pressed("ui_accept"):
		is_ability_toggled = !is_ability_toggled;
		# TODO highlight bottom corner UI icon when ability is toggled
		return;
	
	# on input (WASD), set dest_tile to neighboring tile or to cur_tile with no movement.
	# the turn will process if an ability is used, and the movement will process for the current tile again
	# in case it became dangerous or was dangerous (aoe attacks, fire)
	var dest_tile_coords: Vector2i = _check_directional_input(event);
	var dest_tile = room.get_cell_tile_data(dest_tile_coords);
	
	print(dest_tile_coords)   # DEBUG make sure i'm not running on wrong input
	if not dest_tile: return; # TEMP room.get_cell_tile_data returns null if out of bounds. treat as unwalkable for now
	
	if is_ability_toggled:  # use abilitiy at destination
		use_ability(dest_tile_coords, dest_tile);
		# consider moving in place to proc floor tile again
	elif dest_tile.get_custom_data("is_walkable"):  # move if walkable, else, interact
		move_to_tile(dest_tile_coords, dest_tile);
	# TODO else interact. todo after dialog manager
	
	# if we made it to the end of input, then the heroes 'action' would be used
	# during the combat mechanic, passing the turn priority to enemy actions if enemy count is nonzero
	

# handles movement (WASD) during input function, returns cur_coords if not moving
func _check_directional_input(event) -> Vector2i:
	# default to cur coords
	var dest_tile_coords: Vector2i = cur_coords;
	if event.is_action_pressed("ui_up"): 
		dest_tile_coords = room_map.get_neighbor_cell(cur_coords, TileSet.CELL_NEIGHBOR_TOP_SIDE);
	elif event.is_action_pressed("ui_left"): 
		dest_tile_coords = room_map.get_neighbor_cell(cur_coords, TileSet.CELL_NEIGHBOR_LEFT_SIDE);
		flip_h = false;
	elif event.is_action_pressed("ui_down"): 
		dest_tile_coords = room_map.get_neighbor_cell(cur_coords, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE);
	elif event.is_action_pressed("ui_right"): 
		dest_tile_coords = room_map.get_neighbor_cell(cur_coords, TileSet.CELL_NEIGHBOR_RIGHT_SIDE);
		flip_h = true;
	
	return dest_tile_coords;


# handles ability. toggled with 'E' or 'Enter', directionally fired with movement ability
func use_ability(dest_coords: Vector2i, dest_tile: TileData):
	# to be overriden by each hero
	pass
	


# move hero to destination tile
func move_to_tile(dest_coords: Vector2i, dest_tile: TileData) -> void:
	position = room_map.map_to_local(dest_coords);
	cur_coords = dest_coords;
	cur_tile = dest_tile;
