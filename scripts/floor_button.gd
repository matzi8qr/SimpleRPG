# creates a FloorButton metatile that is pressed when something sits on it
class_name FloorButton extends Entity2D

# button should press and unpress based on its own detection
@onready var room: Room2D = get_parent().get_parent();
@onready var game: Game2D = room.get_parent();

@onready var tile_pos: Vector2i = room.get_map_position(position);

# press and unpress signals
signal pressed;
signal released;

# instance vars
var button_pressed: bool;
var button_echo: bool;
@export var button_id: int;  # connects to array of callables in room2d for multiple floor buttons in a room


func _ready():
	# set button walkable
	is_walkable = true
	
	# connect signals
	game.map_update.connect(_on_map_update);
	
	# TODO connecting multiple buttons to the right callable in each room.
	# array of callables be like
	pressed.connect(room.on_button_presses[button_id]);
	released.connect(room.on_button_releases[button_id]);


# checks and signals if button is pressed or released
func _on_map_update() -> void:
	# check entity layer for something overlapping button
	var entity_pressed: bool;
	for entity in room.entity_list:
		if entity is FloorButton: continue;  # buttons don't push themselves
		entity_pressed = tile_pos == entity.cur_coords;
		# TODO implement and check if entity is flying
		if entity_pressed: break   
	
	# button logic
	if entity_pressed: 
		button_pressed = true;
		if button_echo: pass;  			 # case 1: button held down (pressed = 1, echo = 1)
		else: pressed.emit();  			 # case 2: button stepped on (pressed = 1, echo = 0)
	else:
		button_pressed = false;
		if button_echo: released.emit(); # case 3: button released (pressed = 0, echo = 1)
		else: pass;						 # case 4: button unaffected (pressed = 0, echo = 0)
	
	button_echo = button_pressed;  # update button_echo
	
