class_name Entity2D extends Sprite2D


@export var cur_coords: Vector2i;
@export var is_walkable: bool;


# move sprite to destination tile
func move_to_tile(dest_coords: Vector2i, dest_pos: Vector2) -> void:
	position = dest_pos;
	cur_coords = dest_coords;
