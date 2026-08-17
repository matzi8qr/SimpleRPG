extends Node;
var _music_player_p: AudioStreamPlayer;
var _music_player_c: AudioStreamPlayer;
var _current_music: String = "";
var _off_track: String = "";

const MUSIC_TRACKS: Dictionary = {
	"treeline_p": "res://audio/Music/Treeline - Puzzle.mp3",
	"treeline_c": "res://audio/Music/Treeline - Combat.mp3",
	"forest_p" : "res://audio/Music/Deep Forest - Puzzle.mp3",
	"forest_c" : "res://audio/Music/Deep Forest -Combat.mp3",	
};

var _music_cache: Dictionary = {};

func _ready(): 
	process_mode = Node.PROCESS_MODE_ALWAYS;
	
	
	_music_player_p = AudioStreamPlayer.new();
	_music_player_p.stream = preload("res://audio/Music/Treeline - Puzzle.mp3")
	_music_player_p.bus = "Master";
	_music_player_p.volume_db = -12.0;
	add_child(_music_player_p);
	
	_music_player_c = AudioStreamPlayer.new();
	_music_player_c.stream = preload("res://audio/Music/Treeline - Combat.mp3")
	_music_player_c.bus = "Silent";
	_music_player_c.volume_db = -72;
	add_child(_music_player_c);
	
	_preload_audio();

	
func _preload_audio() -> void:
		for  key in MUSIC_TRACKS:
			var path = MUSIC_TRACKS[key];
			if ResourceLoader.exists(path):
				_music_cache[key] = load(path);
			else:
				push_warning("[AudioManager] Music file not found" + path)

func play_music() -> void:
		_music_player_p.play()
		return;
	
func play_music_silent() -> void:
		_music_player_c.play()
		return; 
		
func play_combat_music() -> void:
	_music_player_c.volume_db = -6.0;
	_music_player_p.volume_db = -72;
	
func play_peace_music() -> void:
	_music_player_p.volume_db = -6.0;
	_music_player_c.volume_db = -72;
	
