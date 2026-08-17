extends Node

static var room_layout: Array[Array];  # use 2d array for world map
static var layout_size: int = 8;
static var cur_index: Vector2i = Vector2i(0, 3);

func _ready() -> void:
	_create_grid();
	
	room_layout[0][3] = load("res://levels/ruins_room.tscn");
	room_layout[1][3] = load("res://levels/ruins_room_1.tscn");
	room_layout[2][3] = load("res://levels/ruins_room_2.tscn");
	room_layout[2][2] = load("res://levels/ruins_room_3.tscn");
	room_layout[3][3] = load("res://levels/path_room.tscn");
	room_layout[3][2] = load("res://levels/path_room_1.tscn");
	room_layout[3][1] = load("res://levels/path_room_2.tscn");
	room_layout[3][0] = load("res://levels/goblin_camp.tscn");
	room_layout[4][1] = load("res://levels/path_room_3.tscn");
	room_layout[3][4] = load("res://levels/wizard_room.tscn");
	

func _create_grid() -> void:
	for x in range(layout_size):
		var col = []
		col.resize(layout_size);
		room_layout.append(col);
	

func get_room_at(index: Vector2i) -> Resource:
	return room_layout[index.x][index.y];
	
func load_room_at(index: Vector2i) -> Room2D:
	return get_room_at(index).instantiate();
