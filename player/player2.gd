extends CharacterBody2D

@export var movement_data : playermovement

var was_wall_normal = Vector2.ZERO
var  current_jumb = 1
var just_wall_jumped = false
var air_jump = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animation_player = $AnimatedSprite2D
@onready var coyote_jumb_timer = $coyote_jumb_timer
func _physics_process(delta):
	
	
	apply_gravity(delta)
	handle_wall_jumb()
	jumb()
	var input_axe = Input.get_axis("ui_left", "ui_right")
	accelerate(input_axe, delta)
	handle_air_acceleration(input_axe, delta)
	apply_friction(input_axe, delta)
	apply_air_resistance(input_axe, delta)
	var was_on_floor = is_on_floor()
	var was_on_wall = is_on_wall_only()
	if was_on_wall:
		was_wall_normal = get_wall_normal()
	player_movement()
	
	play_animachin(input_axe)
	
	
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote_jumb_timer.start()
	pass

func input() -> Vector2:
	var input_dir = Vector2.ZERO
	
	input_dir.x = Input.get_axis("ui_left","ui_right")
	input_dir.normalized()
	
	return input_dir

func handle_wall_jumb():
	if not is_on_wall_only(): return
	var wall_normal = get_wall_normal()
	animation_player.play("wall_jumb")
	if Input.is_action_just_pressed("ui_select"):
		velocity.x = wall_normal.x * movement_data.speed
		velocity.y = movement_data.jumb_power
		
	#if Input.is_action_just_pressed("ui_select") and wall_normal == Vector2.RIGHT:
	#	velocity.x = wall_normal.x * movement_data.speed
	#	velocity.y = movement_data.jumb_power

func handle_air_acceleration(input_axe, delta):
	if is_on_floor() : return
	if input_axe != 0:
		velocity.x = move_toward(velocity.x, movement_data.speed * input_axe, movement_data.air_acceration * delta)


func accelerate(input_axe, delta):
	if not is_on_floor(): return
	if input_axe != 0:
		velocity.x = move_toward(velocity.x, movement_data.speed * input_axe, movement_data.acc * delta)

func apply_friction(input_axis, delta):
	if input_axis == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)

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
		#animation_player.play("jumb")
		print("jumb")

func apply_air_resistance(input_axe , delta):
	if input_axe == 0 and not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.air_resistance * delta)


func jumb():
	if is_on_floor(): air_jump = true
	
	if is_on_floor() or coyote_jumb_timer.time_left > 0.0:
		if Input.is_action_pressed("ui_accept"): 
			velocity.y = movement_data.jumb_power
			coyote_jumb_timer.stop()
	elif not is_on_floor():
		if  Input.is_action_just_released("ui_accept") and velocity.y < movement_data.jumb_power / 2:
			velocity.y = movement_data.jumb_power / 2
			
		if Input.is_action_just_pressed("ui_accept") and air_jump and not just_wall_jumped:
			velocity.y = movement_data.jumb_power * 0.8
			
			air_jump = false
func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * movement_data.gravity * delta
