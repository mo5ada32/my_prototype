extends AudioStreamPlayer

var STARTUVELLY_REFRENSE_GAME_SONG_V_2 = load("res://music/startuvelly-refrense-game-song-v2.mp3")
# Called when the node enters the scene tree for the first time.


var CELLECS_REFRENS_GAME_SONG = load("res://music/cellecs-refrens-game-song.mp3")

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.world_music == 1:
		stream = CELLECS_REFRENS_GAME_SONG
	
	pass
