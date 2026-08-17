class_name Campfire extends Entity2D;


func _ready() -> void:
	is_walkable = false;
	is_opaque = true;
	is_pushable = false;
	

func on_interact() -> String:
	for hero in game.hero_party:
		hero.health = 3;
		hero.health_changed.emit();
	
	return "The fire dances. You dance back. Health restored.";
