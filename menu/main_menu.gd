extends Control

var timer = 0

var paused = false

@onready var animation_player = $AnimationPlayer

@onready var pause_menu = $"pause menu"

var MACHINE_SHAB = preload("res://menu/machine_shab.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func pauseMenu():
	if paused:
		pause_menu.hide() #y5abi pause
		Engine.time_scale = 1 # yi5adaim lo3ba
	
	else :
		pause_menu.show() # yiwari map
		Engine.time_scale = 0 # yipausi lo3ba
	paused = !paused

# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_button_4_pressed():
	animation_player.play("end")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://maps/blasit_level.tscn")
	pass # Replace with function body.


func _on_button_2_pressed():
	pauseMenu()
	pass # Replace with function body.
