extends Node

static var room_layout: Array[Array];  # use 2d array for world map
static var layout_size: int = 8;
static var cur_index: Vector2i = Vector2i(3, 3);

func _ready() -> void:
	_create_grid();
	
	room_layout[3][3] = load("res://levels/test_room.tscn");
	room_layout[3][2] = load("res://levels/test_scene_north.tscn");
	

func _create_grid() -> void:
	for x in range(layout_size):
		var col = []
		col.resize(layout_size);
		room_layout.append(col);
	

func get_room_at(index: Vector2i) -> Resource:
	return room_layout[index.x][index.y];
	
func load_room_at(index: Vector2i) -> Room2D:
	return get_room_at(index).instantiate();
