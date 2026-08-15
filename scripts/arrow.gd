class_name Arrow extends Sprite2D


@export var speed: float = 200.0;


func _process(delta: float) -> void:
	# physical motion of arrow. the mechanics don't actually rely on motion
	# will be awkward with slant bounces though
	# fully change rotation so this moves fine?
	position += transform.x * speed * delta;
	

# for the hit detection... its the old fashioned way
# recursively build arrow_path until the path goes out of bounds, hits an opaque obstacle or entity
