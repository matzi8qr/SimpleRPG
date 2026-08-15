class_name BowHero extends Hero2D

@export var arrow_scene: PackedScene;

# TODO prelaod projectile

func use_ability(dest_coords: Vector2i) -> void:
	var direction: Vector2i = dest_coords - cur_coords;
	
	var arrow = arrow_scene.instantiate();
	arrow.set_launch(position, cur_coords, direction);
	room.add_child(arrow);
	
	#var test_hit: Vector2i = room.get_projectile_path(cur_coords, direction);
	#print("pew pew! would hit = ", test_hit)
	
