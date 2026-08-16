# simple stuff. actions are either move or attack
# iterate through hero_party to find threat range
# either move to closest threat range tile or attack if inside
class_name Enemy2D extends Entity2D;

const DIRECTION_LIST = [Vector2i.UP, Vector2i.LEFT, Vector2i.DOWN, Vector2i.RIGHT];

@onready var game: Game2D = get_tree().root.get_node("Game");

var target_hero: Hero2D;
var can_attack: bool;
var is_dead: bool;


func _ready() -> void:
	# connect signal
	game.enemy_update.connect(_on_enemy_update);
	
	# set base texture
	texture.set_region(Rect2(atlas_region, atlas_region_size))

# signaled from game.process
func _on_enemy_update() -> void:
	cur_coords = game.room.get_map_position(position);
	
	if is_dead: return; # lol
	
	var threat_range: Array[Vector2i] = get_enemy_threat_range();
	print(threat_range)
	
	# TODO process attack!
	if can_attack: 
		attack();
		can_attack = false;
		return;
	
	# now pick our destination out of threat_range by closeness
	var target_tile: Vector2i = pick_closest_tile(cur_coords, threat_range);
	print(target_tile)
	
	# move towards dest_tile
	var dest_tile: Vector2i = pick_movement_tile(target_tile);
	move_to_tile(dest_tile, game.room.get_local_position(dest_tile));
	

# enemy specific override for threat range, default to melee threat
func get_enemy_threat_range() -> Array[Vector2i]:
	# for now, for melee threats, return adjacent
	var threat_range: Array[Vector2i];
	for hero: Hero2D in game.hero_party:  # check every hero in every direction
		for dir: Vector2i in DIRECTION_LIST:
			var query_tile: Vector2i = hero.cur_coords + dir;
			if query_tile not in threat_range: 		  # don't add repeats
				if query_tile == cur_coords:   		  # flag can attack
					target_hero = hero;
					can_attack = true;
					return [query_tile];
				if game.room.is_walkable(query_tile): # only add to threat range if enemy can get there
					threat_range.append(query_tile);
	return threat_range;
	

# picks the closest tile
func pick_closest_tile(tile_from: Vector2i, tiles: Array[Vector2i]) -> Vector2i:
	var closest_tile: Vector2i = tiles.pop_back();
	var closest_dist: float = tile_from.distance_to(closest_tile);
	
	for tile in tiles:  # hood classic
		var dist: float = tile_from.distance_to(tile);
		if dist < closest_dist:
			closest_dist = dist;
			closest_tile = tile;
		
	return closest_tile;
	

# picks the closest 1 tile movement to a target tile
func pick_movement_tile(target_tile: Vector2i) -> Vector2i:
	var possible_movement_tiles: Array[Vector2i];  # build array of adjacent walkable tiles
	for dir in DIRECTION_LIST:
		var tile: Vector2i = cur_coords + dir;
		if tile and game.room.is_walkable(tile): possible_movement_tiles.append(tile);
	
	# return the closest tile to the target tile, or self if cant move
	return cur_coords if possible_movement_tiles.is_empty() else pick_closest_tile(target_tile, possible_movement_tiles);
	

# also to be overriden by specific enemies
func attack() -> void:
	target_hero.hit();
	

func hit() -> void:
	is_dead = true;
	texture.set_region(Rect2(atlas_region_destroyed, atlas_region_size));
	game.room.entity_list.erase(self);
	

func on_interact() -> void:
	# interact is melee attack in case of enemies sooo
	hit();
