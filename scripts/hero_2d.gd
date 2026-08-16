# set up a custom Hero class for all of our characters to use
class_name Hero2D extends Entity2D


@onready var game: Game2D = get_parent();
var health: int = 3;

func _ready() -> void:
	# send self up to game to add to hero party
	game.hero_party.append(self);


# handles ability. toggled with 'E' or 'Enter', directionally fired with movement ability
func use_ability(_dest_coords: Vector2i) -> void:
	# to be overriden by each hero
	pass

# override from entity2d
func hit() -> void:
	print('ow');
