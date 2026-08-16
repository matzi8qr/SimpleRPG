extends Panel

@onready var game: Game2D = get_parent().get_parent();

@onready var HealthDisplay = $FormatContainer/TrayPanel/StatContainer/HealthDisplay;
@onready var TextboxPanel = $FormatContainer/TrayPanel/TextBoxPanel;


func _on_hero_health_changed() -> void:
	HealthDisplay.update_hero_health(game.selected_hero.health);
	

# send text functions down to Textbox
func add_text(text: String) -> void:
	TextboxPanel.add_text(text);
	

func add_each_text(texts: Array) -> void:
	for text in texts: add_text(text);
