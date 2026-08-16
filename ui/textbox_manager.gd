extends Panel


const CHAR_READ_RATE = 0.02;

@onready var Textbox: RichTextLabel = $RichTextLabel;

enum TextboxState {READY, READING, FINISHED};
var cur_state = TextboxState.READY;

var tween: Tween;
var text_queue: Array[String];

signal lock_player_input;
signal unlock_player_input;


func _ready() -> void:
	# connect signals 
	var game = get_tree().root.get_node("/root/Game");  # pls work
	lock_player_input.connect(game.on_lock_player_input);
	unlock_player_input.connect(game.on_unlock_player_input);


func _process(delta: float) -> void:
	match cur_state:
		TextboxState.READY:    # if textbox is not reading and has text in queue, start reading
			if not text_queue.is_empty(): _read_next_text();
		TextboxState.READING:  # skip through text on button mash
			if Input.is_action_just_pressed("skip_text"):
				Textbox.visible_ratio = 1;
				tween.stop();
				cur_state = TextboxState.FINISHED;
		TextboxState.FINISHED: # doesn't auto clear, lets player read until clicked
			if Input.is_action_just_pressed("skip_text"):
				if not text_queue.is_empty(): _read_next_text();
				else: _hide_textbox();
	

# clears text and hides the Textbox and show StatContainer
func _hide_textbox() -> void:
	Textbox.text = "";
	Textbox.visible_ratio = 0;
	tween.stop();
	cur_state = TextboxState.READY;
	unlock_player_input.emit();
	visible = false;
	

func _show_textbox() -> void:
	lock_player_input.emit();
	visible = true;
	

func _read_next_text() -> void:
	cur_state = TextboxState.READING;
	var next_text = text_queue.pop_front();
	Textbox.visible_ratio = 0;
	Textbox.text = next_text;
	
	# free up and reset tween for smooth chats
	if tween: tween.kill();
	tween = get_tree().create_tween();
	tween.connect("finished", _on_tween_finished);
	tween.tween_property(Textbox, "visible_ratio", 1.0, len(next_text) * CHAR_READ_RATE);
	tween.play();
	
	_show_textbox();


func _on_tween_finished() -> void:
	cur_state = TextboxState.FINISHED
	tween.stop()
	

func add_text(text: String) -> void:
	# push a color on each message added
	text_queue.append("[color=AFAF9E]" + text + "[/color]")
	
