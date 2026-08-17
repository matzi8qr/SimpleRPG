extends Room2D


var update_room_scene := load("res://levels/ruins_room_2_1.tscn")

var rock_atlas_coords := Vector2i(4, 13);
var blank_atlas_coords := Vector2i(16, 0);
var gate_atlas_coords := Vector2i(6, 40);
var rock0 := Vector2i(14, 2);
var rock1 := Vector2i(14, 3);
var rock2 := Vector2i(14, 4);
var gate0 := Vector2i(6, 6);
var gate1 := Vector2i(7, 6);
var gate2 := Vector2i(8, 6);
var gate3 := Vector2i(9, 6);

var is_door_open: bool;


func _ready() -> void:
	#if game.flag_got_bow_hero:
		#var update_room = update_room_scene.instantiate();
		#game.add_child(update_room);
		#game.room = update_room
		#queue_free.call_deferred();
	
	#if game.flag_solved_ruins_2:
		#open_gate();
	
	on_button_presses[0] = open_door;
	on_button_releases[0] = close_door;
	on_lever_toggles_on[0] = open_gate;
	on_lever_toggles_off[0] = close_gate;
	

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
	

func open_gate() -> void:
	set_cell("MainTileLayer", gate0, 0, blank_atlas_coords);
	set_cell("MainTileLayer", gate1, 0, blank_atlas_coords);
	set_cell("MainTileLayer", gate2, 0, blank_atlas_coords);
	set_cell("MainTileLayer", gate3, 0, blank_atlas_coords);
	game.flag_solved_ruins_2 = true;
	

func close_gate() -> void:
	set_cell("MainTileLayer", gate0, 0, gate_atlas_coords);
	set_cell("MainTileLayer", gate1, 0, gate_atlas_coords);
	set_cell("MainTileLayer", gate2, 0, gate_atlas_coords);
	set_cell("MainTileLayer", gate3, 0, gate_atlas_coords);
	
