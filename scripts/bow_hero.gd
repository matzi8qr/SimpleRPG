class_name BowHero extends Hero2D

var arrow_scene := load("res://objects/arrow_projectile.tscn");


func _ready() -> void:
	super._ready();
	# potential dirty spawn fix
	move_to_tile(Vector2i(9, 5), game.room.get_local_position(Vector2(9, 5)));
	
	hero_icon = load("res://assets/bow_icon.png");
	

func use_ability(dest_coords: Vector2i) -> void:
	var direction: Vector2i = dest_coords - cur_coords;
	
	var arrow = arrow_scene.instantiate();
	arrow.set_launch(position / 6, cur_coords, direction);
	# since things are scaled by 6 and godot will do whatever it wants with that 6
	game.room.add_child(arrow);
	

func on_interact() -> String:
	return "My elf eyes see plenty.";
	
