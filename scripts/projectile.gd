class_name Projectile extends Area2D

@onready var room: Room2D = get_parent();

@export var speed: float = -200.0;

var launch_pos: Vector2i;
var direction: Vector2i;

var arrow_dest: Vector2i;


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
		flip_h = true;
	if direction == Vector2i.DOWN: rotate(-1.5707)
	

# for the hit detection... its the old fashioned way
# recursively build arrow_path until the path goes out of bounds, hits an opaque obstacle or entity
func _ready() -> void:
	arrow_dest = room.get_projectile_path(launch_pos, direction);
	var target_tile: Variant = room.get_cell_tile_data(arrow_dest);
	if target_tile is Entity2D:
		target_tile.hit();
