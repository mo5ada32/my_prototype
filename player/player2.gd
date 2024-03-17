extends CharacterBody2D

@export var  speed = 300
@export var jumb_power = -900

@export var acc = 50 
@export var friction = 70

@export var gravity = 100

@export var max_jumb = 2

var  current_jumb = 1

@onready var animation_player = $AnimatedSprite2D
@onready var coyote_jumb_timer = $coyote_jumb_timer
func _physics_process(delta):
	var input_dir: Vector2 = input()
	var input_axe = Input.get_axis("ui_left", "ui_right")
	if input_dir != Vector2.ZERO:
		accelerate(input_dir)
		
	else :
		add_friction()
	jumb()
	play_animachin(input_axe)
	var was_on_floor = is_on_floor()
	player_movement()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote_jumb_timer.start()
	pass

func input() -> Vector2:
	var input_dir = Vector2.ZERO
	
	input_dir.x = Input.get_axis("ui_left","ui_right")
	input_dir.normalized()
	
	return input_dir

func accelerate(direction):
	velocity = velocity.move_toward(speed * direction, acc)

func add_friction():
	velocity = velocity.move_toward(Vector2.ZERO, friction)

func player_movement():
	move_and_slide()
	#play_animachin("run")

func play_animachin(in_put_axe):
	if in_put_axe != 0:
		animation_player.flip_h = (in_put_axe < 0)
		animation_player.play("run")
	else :
		animation_player.play("idle")
	
	if not is_on_floor():
		animation_player.play("jumb")
		

func jumb():
	if Input.is_action_just_pressed("ui_up"):
		if current_jumb < max_jumb:
			velocity.y = jumb_power
			current_jumb = current_jumb + 1
			#play_animachin("jumb") 
	else :
		velocity.y += gravity
		
	
	if is_on_floor() or coyote_jumb_timer.time_left > 0.0:
		current_jumb = 1
