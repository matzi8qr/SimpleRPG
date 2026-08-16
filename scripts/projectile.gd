class_name Projectile extends Area2D

@onready var room: Room2D = get_parent();
@onready var game: Game2D = room.get_parent();
@onready var sprite: Sprite2D = $Sprite2D;

@export var speed: float = -300.0;

var launch_pos: Vector2i;
var direction: Vector2i;
var set_flip_h: bool;
var blocked: bool;

var arrow_dest: Vector2i;
var target_tile: Variant;


func _process(delta: float) -> void:
	# physical motion of arrow. the mechanics don't actually rely on motion
	# will be awkward with slant bounces though
	# fully change rotation so this moves fine?
	position += transform.x * speed * delta;
	
	# queue free when arrow reaches destination tile
	if room.get_map_position(position) == arrow_dest:
		queue_free();
	

func set_launch(position: Vector2, launch_pos: Vector2i, direction: Vector2i) -> void:
	self.position = position;  
	self.launch_pos = launch_pos;
	self.direction = direction;
	
	if direction == Vector2i.UP: rotate(1.5707)
	if direction == Vector2i.RIGHT:
		speed *= -1;
		set_flip_h = true;
	if direction == Vector2i.DOWN: rotate(-1.5707)
	

# for the hit detection... its the old fashioned way
# recursively build arrow_path until the path goes out of bounds, hits an opaque obstacle or entity
func _ready() -> void:
	# connect signals to pause game while they fly
	game.on_projectile_spawn();
	tree_exiting.connect(game.on_projectile_despawn);
	
	arrow_dest = room.get_projectile_path(launch_pos, direction);
	target_tile = room.get_cell_tile_data(arrow_dest);
	
	if set_flip_h: sprite.flip_h = true;



func _on_tree_exiting() -> void:
	if target_tile is Entity2D and not blocked:
		target_tile.hit();
