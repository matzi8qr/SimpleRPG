class_name Game2D extends Node2D


const SHIELD_ATLAS_TILE = Vector2i(28, 12);

# references
@onready var room: Room2D = get_child(4);
@onready var ui: Panel = $CanvasLayer/GameUI;
#@onready var room_map: TileMapLayer = room.get_node("MainTileLayer");
#@onready var entity_map: TileMapLayer = room.get_node("EntityTileLayer");

# game vars
var is_process_turn: bool;

var hero_party: Array[Hero2D];
var selected_hero: Hero2D;
var selected_hero_index: int = 0;
var input_locked: bool;
var is_ability_toggled: bool;
var is_await_user_input: bool = true;

var projectile_pause: bool;

# add map_update signal that sounds after each game turn
signal enemy_update;
signal map_update;
signal projectile_despawn;

# handle input inside Game script instead of multiple children
func _input(event: InputEvent) -> void:
	if input_locked: return;
	if not is_await_user_input: return;
	
	if event is InputEventMouse: return;   # this game ignores mouse inputs
	if event is InputEventKey:
		if event.is_echo(): return;		   # and ignores key hold inputs
		if not event.is_pressed(): return; # and ignores key release inputs
		# TODO ignore all other key presses too, save Space (pass) and esc (menu)
	
	# TODO buffer inputs against the turn-based system (and shifting control)
	# turn action economy goes as either move/interact or action
	
	# check for swap_hero input, looping through the hero party
	if event.is_action_pressed("swap_hero"):
		swap_active_hero();
		return;  
	
	# check for ability toggle first, and return - do not process movement and use action
	if event.is_action_pressed("ui_accept"):
		is_ability_toggled = !is_ability_toggled;
		# TODO highlight bottom corner UI icon when ability is toggled
		return;  
	
	# on input (WASD), set dest_tile to neighboring tile or to cur_tile with no movement.
	# the turn will process if an ability is used, and the movement will process for the current tile again
	# in case it became dangerous or was dangerous (aoe attacks, fire)
	var dest_tile_coords: Vector2i = _check_directional_input(event);
	
	if is_ability_toggled:  # use abilitiy at destination
		selected_hero.use_ability(dest_tile_coords);
		is_ability_toggled = false;
	elif room.is_walkable(dest_tile_coords):  # move if walkable, else, interact
		selected_hero.move_to_tile(dest_tile_coords, room.get_local_position(dest_tile_coords));
	# TODO else interact. to start now
	else:
		var dest_tile: Variant = room.get_cell_tile_data(dest_tile_coords); 
		if not dest_tile: warp_to(selected_hero.cur_coords, dest_tile_coords);  # null case out of bounds, try to warp
		elif dest_tile is Entity2D: # call interact on dest tile and send string to dialogue
			var interact_text: String = dest_tile.on_interact(); 
			if not interact_text.is_empty(): ui.add_text(interact_text);
		else: ui.add_text("That's a wall.");  # TODO add "info" layer of strings
	
	# getting to this point in finishing the input clears the game to play on next frame
	# in combat: wait for all available heroes to use their action
	if room.has_enemies:  # case IN COMBAT - use action and swap to next hero
		# TODO 'dim' heroes who have acted
		selected_hero.has_action = false;
		if swap_active_hero(): return;  # can swap hero
		else:							# case out of actions
			reset_hero_actions();
			is_await_user_input = false;
		
	is_await_user_input = false;


# returns true if it can swap, false if out of actions
func swap_active_hero() -> bool:
	if not check_active_heroes(): return false;
	selected_hero_index += 1;
	if selected_hero_index == hero_party.size(): selected_hero_index = 0;
	selected_hero = hero_party[selected_hero_index];
	if not selected_hero.has_action:  # skip hero if has no action
		return swap_active_hero();
		
	selected_hero.health_changed.emit();
	ui.set_hero_icon(selected_hero.hero_icon);
	return true;


func check_active_heroes() -> bool:
	for hero in hero_party:
		if hero.has_action: return true;
	return false;
	

func reset_hero_actions() -> void:
	for hero in hero_party:
		hero.has_action = true;
	swap_active_hero();

# handles movement (WASD) during input function, returns cur_coords if not moving
func _check_directional_input(event) -> Vector2i:
	# default to cur coords
	var cur_coords: Vector2i = selected_hero.cur_coords;
	var dest_tile_coords: Vector2i = cur_coords;
	if event.is_action_pressed("ui_up"): 
		dest_tile_coords = room.get_room_map().get_neighbor_cell(cur_coords, TileSet.CELL_NEIGHBOR_TOP_SIDE);
	elif event.is_action_pressed("ui_left"): 
		dest_tile_coords = room.get_room_map().get_neighbor_cell(cur_coords, TileSet.CELL_NEIGHBOR_LEFT_SIDE);
		selected_hero.flip_h = false;
	elif event.is_action_pressed("ui_down"): 
		dest_tile_coords = room.get_room_map().get_neighbor_cell(cur_coords, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE);
	elif event.is_action_pressed("ui_right"): 
		dest_tile_coords = room.get_room_map().get_neighbor_cell(cur_coords, TileSet.CELL_NEIGHBOR_RIGHT_SIDE);
		selected_hero.flip_h = true;
	
	return dest_tile_coords;

# map transition logic
# check direction of warp based on dest coords, then
# change scene to destination room
# new room has to spawn and add heroes to entity list
func warp_to(cur_coords: Vector2i, dest_coords: Vector2i) -> void:
	var warp_direction: Vector2i;
	var warp_coords: Vector2i = cur_coords;
	
	# check warp direction
	if dest_coords.x < 0:  # exit west side
		warp_direction = Vector2i.LEFT;
		warp_coords.x = room._room_size.x - 1;
	elif dest_coords.y < 0:  # exit north side
		warp_direction = Vector2i.UP;
		warp_coords.y = room._room_size.y - 1;
	elif dest_coords.x >= room._room_size.x: #exit east side
		warp_direction = Vector2i.RIGHT;
		warp_coords.x = 0;
	elif dest_coords.y >= room._room_size.y: # exit south side
		warp_direction = Vector2i.DOWN;
		warp_coords.y = 0;
		
	# get new room from RoomLayout
	RoomLayout.cur_index += warp_direction;
	var new_room: Room2D = RoomLayout.load_room_at(RoomLayout.cur_index);
	add_child(new_room);
	room = new_room;
		
	# move heroes to scene
	for hero in hero_party:
		if hero == selected_hero:
			hero.move_to_tile(warp_coords, new_room.get_local_position(warp_coords));
		else: try_warp_companion(hero, new_room, warp_coords, warp_direction);
	
	# delete old node (ineffecient but clasic rpg to have the room be reset)
	get_child(4).queue_free()
	

func try_warp_companion(companion: Hero2D, new_room: Room2D, warp_dest: Vector2i, warp_direction: Vector2i) -> void:
	var try_warp_coords = warp_dest;
	for i in range(-2, 3):  # checks tiles within +- 2 tiles of hero warp. if maps are made with 3 wide warps it should be ok
		if warp_direction == Vector2i.LEFT or warp_direction == Vector2i.RIGHT: 
			try_warp_coords.y += i;  # check y tiles on horizontal warp.. vice versa
		else: try_warp_coords.x += i;
		if new_room.is_walkable(try_warp_coords):
			companion.move_to_tile(try_warp_coords, new_room.get_local_position(try_warp_coords));
			return;

# game loop of the rpg. waits for player input and then
# resolves enemies and the map in that order
func _process(_delta: float) -> void:
	if is_await_user_input: return;
	if is_process_turn: return;
	else: _process_turn();
	

func _process_turn() -> void:
	is_process_turn = true;
	
	# first get player input
	if is_await_user_input: return;
	
	# then wait for projectiles
	if projectile_pause: await projectile_despawn;
	
	# update enemies
	enemy_update.emit();
	
	# wait for projectiles
	if projectile_pause: await projectile_despawn;
	
	# update world and do the same thing
	map_update.emit();
	
	if projectile_pause: await projectile_despawn;
	
	room.clear_shields();
	is_await_user_input = true;
	is_process_turn = false;

func _on_shield_timeout() -> void:
	pass
	## TODO lighting/saturation fade out?
	#var misc_map = room.get_node("MiscTileLayer");
	#for coords in hero_party[0].shield_tiles:
		#if misc_map.get_cell_atlas_coords(coords) == SHIELD_ATLAS_TILE:
			#misc_map.set_cell(coords, -1)
		#
	#hero_party[0].shield_tiles.clear()

func on_projectile_spawn() -> void:
	projectile_pause = true;
	

func on_projectile_despawn() -> void:
	projectile_pause = false;
	projectile_despawn.emit()

func on_lock_player_input(): input_locked = true;
func on_unlock_player_input(): input_locked = false;
