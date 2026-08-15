class_name BowHero extends Hero2D

@export var arrow_scene: PackedScene;


func use_ability(dest_coords: Vector2i) -> void:
	var direction: Vector2i = dest_coords - cur_coords;
	
	var arrow = arrow_scene.instantiate();
	arrow.set_launch(position, cur_coords, direction);
	room.add_child(arrow);
	
