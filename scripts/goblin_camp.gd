extends Room2D

var bow_hero_scene := load("res://heroes/BowHero.tscn");
var bow_hero_spawn := Vector2i(9, 5);


func _ready() -> void:
	var bow_hero: Hero2D = bow_hero_scene.instantiate();
	bow_hero.move_to_tile(bow_hero_spawn, game.room.get_local_position(bow_hero_spawn));
	super._ready();
