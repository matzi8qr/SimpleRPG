# set up custom Room class that saves and preloads its own Scene and points
# towards directional neighbors to recursively build the map (setup for procedural gen?)
# Room2D will also parent and manage both TileMapLayers
class_name Room2D extends Node2D

# map scene
# TODO room scene with tile map layers and preload in _ready

# references
@onready var game: Game2D = get_parent();
@onready var _room_map: TileMapLayer = $MainTileLayer;
@onready var _misc_map: TileMapLayer = $MiscTileLayer;
@onready var _entity_map: TileMapLayer = $EntityTileLayer;

var entity_list: Array[Entity2D];

# instance vars
@export var _room_size: Vector2i = Vector2i(16, 9);

# connected rooms
# TODO setup directional rooms

# fill arrays with button functions as needed to auto connect. and override empty button func
var on_button_presses: Array[Callable] = [func(): print("empty button pressed!")];
var on_button_releases: Array[Callable] = [func(): print("empty button released!")];


# set up children node in process bc theyre not ready by ready
func _process(_delta: float) -> void:
	if entity_list.is_empty(): _init_entity_list();
		

func _init_entity_list():
	var entity_nodes = _entity_map.get_children();
	for entity in entity_nodes:
		entity.cur_coords = _entity_map.local_to_map(entity.position);
		entity_list.append(entity as Entity2D)
	print (entity_list)
	

# Checks the targetted tile against both entity and room map and returns the tile data
# Behavior on out of bounds? Soon it will warp to connected rooms. are all rooms 16 by 9?
# if not the camera gotta move
# returns null if out of bounds, entity if entity found, and tiledata if neither
func get_cell_tile_data(tile: Vector2i) -> Variant:
	# if the destination is out of bounds, for now, return null and handle in hero_2d
	if tile.x < 0 or tile.x > _room_size.x: return null;
	if tile.y < 0 or tile.y > _room_size.y: return null;
	
	# check entity layer first, return room tile if empty
	for entity in entity_list:
		if tile == entity.cur_coords: return entity;
	
	return _room_map.get_cell_tile_data(tile);
	

# checks both tile layers and returns true if walkable
func is_walkable(dest_coords: Vector2i) -> bool:
	var dest_tile = get_cell_tile_data(dest_coords);
	if not dest_tile: return false;  # out of bounds or no tile found
	
	# if entity: check if walkable (pressure plate), for now, entities unwalkable
	if dest_tile is Entity2D: return dest_tile.is_walkable;
	
	# now check main layer walkability
	return dest_tile.get_custom_data("is_walkable");
	

# attempts to push entity in given direction. return true if entity is pushed or tile is empty
func try_push_entity(tile: Vector2i, direction: Vector2i) -> bool:
	# find entity on tile
	var push_entity: Entity2D;
	for entity in entity_list:
		if entity.cur_coords == tile: 
			push_entity = entity;
			break
	
	if not push_entity or not push_entity.is_opaque: return true;  # if entity not found, tile is empty
	
	if not is_walkable(tile + direction): return false;  # pushed into walls or out of bounds
	# TODO chain pushing entities would be funny. for now use predefined walkability
	# pushing things into water or lava should also work
	
	# 'pushing' the entity
	push_entity.move_to_tile(tile + direction, _entity_map.map_to_local(tile + direction));
	return true;  # true if entity pushed or tile is empty
	

# recusively get projectile path, ending with what it hits. allows 'null' tiles
# TODO interact with slant tiles and change direction
func get_projectile_path(last_pos: Vector2i, direction: Vector2i) -> Vector2i:
	var this_pos: Vector2i = last_pos + direction;
	var path_tile: Variant = get_cell_tile_data(this_pos);
	
	if not path_tile: return this_pos;   				# base case null tile out of bounds
	if path_tile is Entity2D and path_tile.is_opaque:   # base case hit entity. TODO hit detection
		return this_pos;  
	if path_tile is TileData and path_tile.get_custom_data("is_opaque"): # base case hit wall
		return this_pos; 
	
	return get_projectile_path(this_pos, direction); # recursive case, check next pos


func get_map_position(local_pos: Vector2) -> Vector2i:
	return _room_map.local_to_map(local_pos);

func get_local_position(map_pos: Vector2i) -> Vector2:
	return _room_map.map_to_local(map_pos);

func get_room_map() -> TileMapLayer:
	return _room_map;

func get_misc_map() -> TileMapLayer:
	return _misc_map;

func get_entity_map() -> TileMapLayer:
	return _entity_map;

func get_room_size() -> Vector2i:
	return _room_size;
