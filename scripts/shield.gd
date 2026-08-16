class_name Shield extends Area2D


# block arrow
func _on_area_entered(area: Area2D) -> void:
	if area is Projectile: 
		area.blocked = true;
		area.queue_free();
