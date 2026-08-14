class_name Hero2D extends Sprite2D


@onready var entity_map: TileMapLayer = get_parent();
@onready var room_map: TileMapLayer = entity_map.get_parent().get_child(0);
@onready var cur_coords: Vector2i = room_map.local_to_map(position);
@onready var cur_tile: TileData = room_map.get_cell_tile_data(cur_coords);

func _ready() -> void:
	# TODO replace spawn tile with blank tile. 
	# currently its a black background which may cause future problems
	# when interacting with the tile map
	pass


func _input(event):
	if event is InputEventMouse: return;   # this game ignores mouse inputs
	if event is InputEventKey:
		if event.is_echo(): return;		   # and ignores key hold inputs
		if not event.is_pressed(): return; # and ignores key release inputs
	
	# TODO buffer inputs against the turns
	# TODO process actioon input as well
	# turn action economy goes as either move/interact or action
	
	# on input (WASD), set dest_tile to neighboring tile or to cur_tile with no movement.
	# the turn will process if an ability is used, and the movement will process for the current tile again
	# in case it became dangerous or was dangerous (aoe attacks, fire)
	var dest_tile_coords: Vector2i = _check_movement_input(event);
	print(dest_tile_coords)  # DEBUG make sure i'm not running on wrong input
	var dest_tile: TileData = room_map.get_cell_tile_data(dest_tile_coords);
	# move if walkable, else, interact
	if dest_tile.get_custom_data("is_walkable"): move_to_tile(dest_tile_coords, dest_tile);
	# TODO interact
	

# handles movement (WASD) during input function, returns cur_coords if not moving
func _check_movement_input(event) -> Vector2i:
	# default to cur coords
	var dest_tile_coords: Vector2i = cur_coords;
	if event.is_action_pressed("ui_up"): 
		dest_tile_coords = room_map.get_neighbor_cell(cur_coords, TileSet.CELL_NEIGHBOR_TOP_SIDE);
	elif event.is_action_pressed("ui_left"): 
		dest_tile_coords = room_map.get_neighbor_cell(cur_coords, TileSet.CELL_NEIGHBOR_LEFT_SIDE);
	elif event.is_action_pressed("ui_down"): 
		dest_tile_coords = room_map.get_neighbor_cell(cur_coords, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE);
	elif event.is_action_pressed("ui_right"): 
		dest_tile_coords = room_map.get_neighbor_cell(cur_coords, TileSet.CELL_NEIGHBOR_RIGHT_SIDE);
	
	return dest_tile_coords;


# move hero to destination tile
func move_to_tile(dest_coords: Vector2i, dest_tile: TileData) -> void:
	position = room_map.map_to_local(dest_coords);
	cur_coords = dest_coords;
	cur_tile = dest_tile;


# TODO ability mechanics
# define ability variables and code them for each Hero
