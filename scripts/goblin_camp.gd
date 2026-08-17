extends Room2D

var bow_hero_scene := load("res://heroes/BowHero.tscn");
var bow_hero_spawn := Vector2i(9, 5);


func _ready() -> void:
	super._ready();
	
	if not game.flag_got_bow_hero:
		var bow_hero: Hero2D = bow_hero_scene.instantiate();
		game.add_child(bow_hero);
		bow_hero.z_index = 2;
		bow_hero.move_to_tile(bow_hero_spawn, game.room.get_local_position(bow_hero_spawn));
		
		game.ui.add_text("Huzzah! Reinforcements!\nThat shield of yours might serve plenty useful.");
		game.ui.add_text("BOW MAN has joined the party. You can (Shift) between your HEROES.\nEach one gets to act per turn!");
		game.flag_got_bow_hero = true;
