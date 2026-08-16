extends Panel

@onready var game: Game2D = get_parent().get_parent();

@onready var HealthDisplay = $FormatContainer/TrayPanel/StatContainer/HealthDisplay;


func _on_hero_health_changed() -> void:
	HealthDisplay.update_hero_health(game.selected_hero.health);
