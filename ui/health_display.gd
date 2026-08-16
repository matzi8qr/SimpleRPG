extends HBoxContainer

@export var heart_scene: PackedScene;

func update_hero_health(health: int) -> void:
	# clear all hearts
	for heart in get_children():
		heart.queue_free();
	
	for hit_point in health:
		add_child(heart_scene.instantiate());
		
