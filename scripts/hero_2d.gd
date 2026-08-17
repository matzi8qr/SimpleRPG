# set up a custom Hero class for all of our characters to use
class_name Hero2D extends Entity2D


@export var hero_icon: Texture;
var has_action: bool = true;

var health: int = 3;
signal health_changed;

func _ready() -> void:
	# send self up to game to add to hero party
	game.hero_party.append(self);


# handles ability. toggled with 'E' or 'Enter', directionally fired with movement ability
func use_ability(_dest_coords: Vector2i) -> void:
	# to be overriden by each hero
	pass

# override from entity2d
func hit() -> void:
	health -= 1;
	health_changed.emit();
	
	# hero death? temporarily remove from hero party and force switch party
	# dont remove, allow revive
	# prevent warps? heroes are not deleted, make a way to "move" them off screen on warp
	# for now do ui
