class_name Lever extends Entity2D

@onready var room: Room2D = get_parent().get_parent();
@onready var game: Game2D = room.get_parent();

signal toggled_on;
signal toggled_off;

@onready var tile_pos: Vector2i = room.get_map_position(position);
@export var lever_id: int;

# logic
var is_toggled: bool;
var is_toggled_echo: bool;
var projectile_triggered: bool;
var interact_triggered: bool;


func _ready() -> void:
	is_walkable = false;
	is_opaque = true;  # counts as cover since projectiles interact with it
	
	# connect signals
	game.map_update.connect(_on_map_update);
	# connect to arrays for multiple switch rooms
	toggled_on.connect(room.on_lever_toggles_on[lever_id]);
	toggled_off.connect(room.on_lever_toggles_off[lever_id]);
	

func _on_map_update() -> void:
	if projectile_triggered:  # case triggered by projectile (set by hit)
		is_toggled = not is_toggled;
		projectile_triggered = false;
	
	# check entity layer for overlap -> instead, should be on interact
	#for entity in room.entity_list:
		#if entity is Lever: continue;  # levers don't toggle themselves
		## TODO implement and check if entity is flying
		#if tile_pos == entity.cur_coords: 
			#is_toggled = not is_toggled;  # switch switches on overlap
			#break;
	if interact_triggered:
		is_toggled = not is_toggled;
		interact_triggered = false;
	
	# lever logic
	if is_toggled and not is_toggled_echo: toggled_on.emit();    # case turned on (toggle = 1, echo = 0)
	elif not is_toggled and is_toggled_echo: toggled_off.emit(); # case turned off (toggle = 0, echo = 1)
	is_toggled_echo = is_toggled;
	
	flip_h = is_toggled;  # visual cue for lever


func hit() -> void:
	projectile_triggered = true;
	

func on_interact() -> void:
	interact_triggered = true;
