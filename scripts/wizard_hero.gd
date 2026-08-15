class_name WizardHero extends Hero2D

@export var fireball_scene: PackedScene;

# TODO create flammable things (crates, push barrels, regenerating plants)
# to turn into fire tiles that spread/burn out
# no, trees will not be flammable since thems the primary wall

func use_ability(dest_coords: Vector2i) -> void:
	var direction: Vector2i = dest_coords - cur_coords;
	
	var fireball = fireball_scene.instantiate();
	fireball.set_launch(position, cur_coords, direction);
	room.add_child(fireball);
	

func on_interact() -> void:
	print("Eh? Did somebody say 'cast fireball'?")
