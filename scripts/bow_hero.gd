class_name BowHero extends Hero2D

@export var arrow_scene: PackedScene;


func use_ability(dest_coords: Vector2i) -> void:
	var direction: Vector2i = dest_coords - cur_coords;
	
	var arrow = arrow_scene.instantiate();
	arrow.set_launch(position / 6, cur_coords, direction);
	# since things are scaled by 6 and godot will do whatever it wants with that 6
	game.room.add_child(arrow);
	
	

func on_interact() -> void:
	print("My elf eyes see plenty.");
	
