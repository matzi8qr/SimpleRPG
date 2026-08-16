class_name BowEnemy extends Enemy2D;


@export var arrow_scene: PackedScene;
var target_direction: Vector2i;

# override for ranged protectile
func get_enemy_threat_range() -> Array[Vector2i]:
	var threat_range: Array[Vector2i];
	
	for hero: Hero2D in game.hero_party:  # check every hero in every direction
		for dir: Vector2i in DIRECTION_LIST:
			var projectile_range: Vector2i = game.room.get_projectile_path(hero.cur_coords, dir);
			var query_tile: Vector2i = hero.cur_coords + dir;
			
			while query_tile != projectile_range:  		# starting at 2 away, if they equal then no room for range attack (1 block from obstacle)
				query_tile += dir;  			   		# loop case add 1 first to ignore melee and otherwise it can't see itself
				if query_tile in threat_range: continue # don't add repeats
				if query_tile == cur_coords:   			# flag can attack
					target_hero = hero;
					target_direction = dir * -1;
					can_attack = true;
					return [query_tile];
				if game.room.is_walkable(query_tile): # only add to threat range if walkable
					threat_range.append(query_tile);
			
	return threat_range;
	

func attack() -> void:
	# shoot bow
	var arrow: Projectile = arrow_scene.instantiate();
	arrow.set_launch(position, cur_coords, target_direction);
	game.room.add_child(arrow);
	
