extends PushBarrel


func on_interact() -> String:
	return "This barrel thinks it's soo tough...\nsurrounded by flammable materials...";


func get_pushed() -> void:
	game.ui.add_text("What did you think would happen?");
