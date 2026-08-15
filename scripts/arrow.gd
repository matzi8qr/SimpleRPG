class_name Arrow extends Sprite2D

@onready var arrow_launcher: Entity2D = get_parent();

@export var speed: float = 200.0;

var launch_pos: Vector2i;
var direction: Vector2i;

var arrow_path: Array[Vector2i];


func _process(delta: float) -> void:
	# physical motion of arrow. the mechanics don't actually rely on motion
	# will be awkward with slant bounces though
	# fully change rotation so this moves fine?
	position += transform.x * speed * delta;
	
	# TODO queue free when/where off screen/hits null
	

func _init(launch_pos: Vector2i, direction: Vector2i) -> void:
	self.launch_pos = launch_pos;
	self.direction = direction;
	

# for the hit detection... its the old fashioned way
# recursively build arrow_path until the path goes out of bounds, hits an opaque obstacle or entity
func _ready() -> void:
	arrow_path = arrow_launcher.room.build_projectile_path(arrow_path, launch_pos, direction);
