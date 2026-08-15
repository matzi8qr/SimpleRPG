class_name Game2D extends Node2D


# references
@onready var room: Room2D = get_child(0);
@onready var room_map: TileMapLayer = room.get_node("MainTileLayer");
@onready var entity_map: TileMapLayer = room.get_node("EntityTileLayer");

# game vars
var hero_party: Array[Hero2D];
var selected_hero: Hero2D;
var paused: bool;
var is_ability_toggled: bool;
var is_await_user_input: bool = true;

# add map_update signal that sounds after each game turn
signal map_update;
	

# handle input inside Game script instead of multiple children
func _input(event: InputEvent) -> void:
	if paused: return;
	if not is_await_user_input: return;
	
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
	
	if is_ability_toggled:  # use abilitiy at destination
		selected_hero.use_ability(dest_tile_coords);
		is_ability_toggled = false;
	elif room.is_walkable(dest_tile_coords):  # move if walkable, else, interact
		selected_hero.move_to_tile(dest_tile_coords, entity_map.map_to_local(dest_tile_coords));
	# TODO else interact. todo after dialog manager
	
	# getting to this point in finishing the input clears the game to play on next frame
	# in combat: wait for all available heroes to use their action
	is_await_user_input = false;


# handles movement (WASD) during input function, returns cur_coords if not moving
func _check_directional_input(event) -> Vector2i:
	# default to cur coords
	var cur_coords: Vector2i = selected_hero.cur_coords;
	var dest_tile_coords: Vector2i = cur_coords;
	if event.is_action_pressed("ui_up"): 
		dest_tile_coords = room_map.get_neighbor_cell(cur_coords, TileSet.CELL_NEIGHBOR_TOP_SIDE);
	elif event.is_action_pressed("ui_left"): 
		dest_tile_coords = room_map.get_neighbor_cell(cur_coords, TileSet.CELL_NEIGHBOR_LEFT_SIDE);
		selected_hero.flip_h = false;
	elif event.is_action_pressed("ui_down"): 
		dest_tile_coords = room_map.get_neighbor_cell(cur_coords, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE);
	elif event.is_action_pressed("ui_right"): 
		dest_tile_coords = room_map.get_neighbor_cell(cur_coords, TileSet.CELL_NEIGHBOR_RIGHT_SIDE);
		selected_hero.flip_h = true;
	
	return dest_tile_coords;


# game loop of the rpg. waits for player input and then
# resolves enemies and the map in that order
func _process(_delta: float) -> void:
	if is_await_user_input: return;
	
	# TODO process enemy state machines,
	# choose and update an action for each
	# use a quick timer to give each one time to move
	
	print("world update! START HERE TOMORROW :3")
	# signal map update to trigger metatiles (pressure plates, turrets)
	
	# await user input at the end
	is_await_user_input = true;
	
