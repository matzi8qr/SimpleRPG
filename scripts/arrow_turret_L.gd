extends Turret

func _ready() -> void:
	super._ready();
	direction = Vector2i.LEFT;


func on_interact() -> String:
	return "This is a turret. You might want to move.";
