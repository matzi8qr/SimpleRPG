class_name Entity2D extends Sprite2D

@onready var game: Game2D = get_tree().root.get_node("/root/Game");

@export var cur_coords: Vector2i;
@export var is_walkable: bool;
@export var is_opaque: bool = true;
@export var is_pushable: bool = true;

@export var atlas_region: Vector2;
@export var atlas_region_destroyed: Vector2;
const atlas_region_size = Vector2(12.0, 12.0);


# move sprite to destination tile
func move_to_tile(dest_coords: Vector2i, dest_pos: Vector2) -> void:
	global_position = dest_pos;
	cur_coords = dest_coords;
	

# on_hit basically, called by Room2D for hitdetection
# to be overriden as things get hit
func hit() -> void:
	pass;
	

# on_interact, even if for the most part its just a string to a dialogue
# TODO play nice with dialogue manager, probably return a string or smth?
# also TODO have enemies turn this into melee 'hit'
func on_interact() -> String:
	return "you found: " + self.to_string();
	

func get_pushed() -> void:
	# TODO override enemies get stunned/staggered
	pass
