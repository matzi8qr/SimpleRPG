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
	
	# TODO check entity layer first
	return _room_map.get_cell_tile_data(tile);
	

func get_room_map() -> TileMapLayer:
	return _room_map;

func get_entity_map() -> TileMapLayer:
	return _entity_map;

func get_room_size() -> Vector2i:
	return _room_size;
