extends Room2D

var rock_atlas_coords := Vector2i(4, 13);
var blank_atlas_coords := Vector2i(16, 0);
var rock0 := Vector2i(14, 2);
var rock1 := Vector2i(14, 3);
var rock2 := Vector2i(14, 4);

var switch_count: int;


func _ready() -> void:
	on_lever_toggles_on[0] = open_door;
	on_lever_toggles_off[0] = close_door;

# connect switch_0 to rock door
func open_door() -> void:
	if switch_count == 0: game.ui.add_text("Who wouldnt?");
	elif switch_count == 1: game.ui.add_text("This is fun!");
	elif switch_count == 2: game.ui.add_text("OK, this is getting old now.");
	else: game.ui.add_text("...");
		
	set_cell("MainTileLayer", rock0, 0, blank_atlas_coords);
	set_cell("MainTileLayer", rock1, 0, blank_atlas_coords);
	set_cell("MainTileLayer", rock2, 0, blank_atlas_coords);
	switch_count += 1;
	

func close_door() -> void:
	if switch_count == 1: game.ui.add_text("Why not?");
	elif switch_count == 2: game.ui.add_text("Hasn't been flipped in ages!");
	elif switch_count == 3: game.ui.add_text("This is becoming counter productive, isn't it?");
	else: game.ui.add_text("... it's probably sick of being flipped now...");
		
	set_cell("MainTileLayer", rock0, 0, rock_atlas_coords);
	set_cell("MainTileLayer", rock1, 0, rock_atlas_coords);
	set_cell("MainTileLayer", rock2, 0, rock_atlas_coords);
