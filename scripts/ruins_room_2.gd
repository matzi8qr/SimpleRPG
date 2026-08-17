extends Room2D


var rock_atlas_coords := Vector2i(4, 13);
var blank_atlas_coords := Vector2i(16, 0);
var rock0 := Vector2i(14, 2);
var rock1 := Vector2i(14, 3);
var rock2 := Vector2i(14, 4);

var is_door_open: bool;


func _ready() -> void:
	on_button_presses[0] = open_door;
	on_button_releases[0] = close_door;
	

func open_door() -> void:
	set_cell("MainTileLayer", rock0, 0, blank_atlas_coords);
	set_cell("MainTileLayer", rock1, 0, blank_atlas_coords);
	set_cell("MainTileLayer", rock2, 0, blank_atlas_coords);
	is_door_open = true;
	

func close_door() -> void:
	set_cell("MainTileLayer", rock0, 0, rock_atlas_coords);
	set_cell("MainTileLayer", rock1, 0, rock_atlas_coords);
	set_cell("MainTileLayer", rock2, 0, rock_atlas_coords);
	is_door_open = false;
