# set up custom Room class that saves and preloads its own Scene and points
# towards directional neighbors to recursively build the map (setup for procedural gen?)
# Room2D will also parent and manage both TileMapLayers
class_name Room2D extends Node2D

# map scene
# TODO room scene with tile map layers and preload in _ready

# references
@onready var _room_map: TileMapLayer = $MainTileLayer;
@onready var _entity_map: TileMapLayer = $EntityTileLayer;


# instance vars
@export var _room_size: Vector2i;

# connected rooms
# TODO setup directional rooms

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	

# Checks the targetted tile against both entity and room map and returns the tile data
# Behavior on out of bounds? Soon it will warp to connected rooms. are all rooms 16 by 9?
# if not the camera gotta move
func get_cell_tile_data(tile: Vector2i) -> TileData:
	# if the destination is out of bounds, for now, return null and handle in hero_2d
	if tile.x < 0 or tile.x > _room_size.x: return null;
	if tile.y < 0 or tile.y > _room_size.y: return null;
	
	# check entity layer first, return room tile if empty
	var entity_tile = _entity_map.get_cell_tile_data(tile);
	var room_tile = _room_map.get_cell_tile_data(tile);
	return entity_tile if entity_tile else room_tile;
	

# attempts to push entity in given direction. return true if entity is pushed or tile is empty
func try_push_entity(tile: Vector2i, direction: Vector2i) -> bool:
	var push_tile_entity: TileData = _entity_map.get_cell_tile_data(tile);
	var dest_tile: TileData = get_cell_tile_data(tile + direction);
	
	if not push_tile_entity: return true;  # nothing to push, return true
	if not dest_tile: return false;  # destination out of bounds, returns null, return unmoved
	if not dest_tile.get_custom_data("is_walkable"): return false;  # pushed into wall, stunned but unmoved
	
	# now 'pushes' entity
	var source_id = _entity_map.get_cell_source_id(tile);
	var atlas_coords = _entity_map.get_cell_atlas_coords(tile);
	_entity_map.set_cell(tile + direction, source_id, atlas_coords);
	_entity_map.set_cell(tile, -1);  # gets replaced by shield
	
	return true;


func get_room_map() -> TileMapLayer:
	return _room_map;

func get_entity_map() -> TileMapLayer:
	return _entity_map;

func get_room_size() -> Vector2i:
	return _room_size;
