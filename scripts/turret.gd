class_name Turret extends Entity2D


@onready var room: Room2D = get_parent().get_parent();
@onready var game: Game2D = room.get_parent();

@export var projectile: PackedScene;
@onready var tile_pos: Vector2i = room.get_map_position(position);

@export var reload_time: int = 3;
var reload_counter: int;
@export var direction: Vector2i = Vector2i.RIGHT;  # please use a normal orthogonal vector ^^


func _ready() -> void:
	game.map_update.connect(_on_map_update);
	

# count up x turns and shoot on the last one

func _on_map_update() -> void:
	reload_counter += 1;
	if reload_counter == reload_time:
		reload_counter = 0;
		_launch_projectile();
	

func _launch_projectile() -> void:
	var shot = projectile.instantiate(); 
	shot.set_launch(position, tile_pos, direction);
	room.add_child(shot);
