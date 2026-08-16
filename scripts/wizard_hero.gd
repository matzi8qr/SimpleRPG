class_name WizardHero extends Hero2D

@export var fireball_scene: PackedScene;

# TODO create flammable things (crates, push barrels, regenerating plants)
# to turn into fire tiles that spread/burn out
# no, trees will not be flammable since thems the primary wall

func use_ability(dest_coords: Vector2i) -> void:
	var direction: Vector2i = dest_coords - cur_coords;
	
	var fireball = fireball_scene.instantiate();
	fireball.set_launch(position / 6, cur_coords, direction);
	# since things are scaled by 6 and godot will do whatever it wants with that 6
	game.room.add_child(fireball);
	

func on_interact() -> String:
	return "Eh? Did somebody say 'cast fireball'?";
