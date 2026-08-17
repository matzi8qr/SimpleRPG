extends PushBarrel


func on_interact() -> String:
	if cur_coords == Vector2i(5, 3):
		return "It's a barrel, stood smugly in the way.\nPerhaps your shield (E or Enter) can show it manners.";
	else: return "It's a barrel. Though its ego has been shattered, it stands firm."
