# set up a custom Hero class for all of our characters to use
class_name Hero2D extends Entity2D


@onready var game: Game2D = get_parent();

func _ready() -> void:
	# send self up to game to add to hero party
	game.hero_party.append(self);


# handles ability. toggled with 'E' or 'Enter', directionally fired with movement ability
func use_ability(_dest_coords: Vector2i) -> void:
	# to be overriden by each hero
	pass
	

#func move_to_tile(dest_coords: Vector2i, dest_pos: Vector2) -> void:
	#position = dest_pos;
	#cur_coords = dest_coords;
