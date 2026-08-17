extends Entity2D

var button_coords = Vector2i(5, 1);
var default_coords = Vector2i(5, 2);

var interact_count: int;
var intro_message = ["Oh good heavens!", "A new face? From the RUINS?"]
var intro_message_1 = ["The strong silent type, I see!", "HERB: The name's HERB.\nPleasure to meet you.\n", "Now if only somebody could do something about those suspiciously shaped stones\non the path to WORMTOWN..."]


func on_interact() -> String:
	if interact_count == 0:
		game.ui.add_each_text(intro_message);
		# queue ... + blank face
		game.ui.add_each_text(intro_message_1);
		interact_count += 1;
	elif game.room.is_door_open: "Perfect! Where do you reckon those stones go, anyway?";
	else: return "Now if only somebody could do something about those suspiciously shaped stones\non the path to WORMTOWN..."
		
	return "";
	

func get_pushed() -> void:
	if cur_coords == button_coords:
		game.ui.add_text("Hey! that was quite -- oh! I see!\nFantastic! Let's go!");
		await game.ui.TextboxPanel.unlock_player_input;
		move_to_tile(default_coords, game.room.get_local_position(default_coords));
		game.room.close_door();
		game.ui.add_text("...");
		game.ui.add_text("I see.")
		await game.ui.TextboxPanel.unlock_player_input;
		move_to_tile(button_coords, game.room.get_local_position(button_coords));
		game.room.open_door();
		
	else: game.ui.add_text("Hey! that was quite rude, there, chap!");
