extends Room2D

var wizard_scene := load("res://heroes/WizardHero.tscn");
var wizard_spawn := Vector2i(6, 5);

var blank_atlas_coords := Vector2i(16, 0);
var gate := Vector2i(7, 4);

var is_button_pressed = false;
var is_lever_switched = false;

func _ready() -> void:
	#if not game.flag_wizard_get:
		#game.flag_wizard_get = true;
		#var wizard = wizard_scene.instantiate();
	
	on_lever_toggles_on[0] = check_lever_open;
	on_lever_toggles_off[0] = func(): is_lever_switched = false;
	on_button_presses[0] = check_button_open;

func check_button_open() -> void:
	is_button_pressed = true;
	if is_button_pressed and is_lever_switched: open_gate();
	

func check_lever_open() -> void:
	is_lever_switched = true;
	if is_button_pressed and is_lever_switched: open_gate();
	

func open_gate() -> void:
	pass;
	
