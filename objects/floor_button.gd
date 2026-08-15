# creates a FloorButton metatile that is pressed when something sits on it
class_name FloorButton extends Sprite2D

# button should press and unpress based on its own detection
@onready var room: Room2D = get_parent().get_parent();
@onready var game: Game2D = room.get_parent();
@onready var entity_map: TileMapLayer = room.get_node("EntityTileLayer");

@onready var tile_pos: Vector2i = entity_map.local_to_map(position);

# press and unpress signals
signal pressed;
signal released;

# instance vars
var button_pressed: bool;
var button_echo: bool;
@export var button_id: int;  # connects to array of callables in room2d for multiple floor buttons in a room
var is_walkable = true;

func _ready():
	# connect signals
	game.map_update.connect(_on_map_update);
	
	# TODO connecting multiple buttons to the right callable in each room.
	# array of callables be like
	pressed.connect(room.on_button_presses[button_id]);
	released.connect(room.on_button_releases[button_id]);


# checks and signals if button is pressed or released
func _on_map_update() -> void:
	# check entity layer for something overlapping button
	var entity_tile = entity_map.get_cell_tile_data(tile_pos);
	print(entity_tile)
	print(entity_map.get_cell_alternative_tile(tile_pos));
	
	if entity_tile:  # TODO implement and check if entity is flying
		button_pressed = true;
		if button_echo: pass;  			 # case 1: button held down (pressed = 1, echo = 1)
		else: pressed.emit();  			 # case 2: button stepped on (pressed = 1, echo = 0)
	else:
		button_pressed = false;
		if button_echo: released.emit(); # case 3: button released (pressed = 0, echo = 1)
		else: print("sad button");						 # case 4: button unaffected (pressed = 0, echo = 0)
	
	button_echo = button_pressed;  # update button_echo
	
