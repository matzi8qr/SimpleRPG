class_name BowHero extends Hero2D


# TODO prelaod projectile

func use_ability(dest_coords: Vector2i) -> void:
	var direction: Vector2i = dest_coords - cur_coords;
	
	var test_path: Array[Vector2i] = room.build_projectile_path([], cur_coords, direction);
	print("pew pew! testpath = ", test_path)
	
