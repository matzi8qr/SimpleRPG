extends Turret

func _ready() -> void:
	super._ready();
	direction = Vector2i.LEFT;


func on_interact() -> void:
	print("This is a turret. You might want to move.");
