extends "state.gd"

@export var climb_speed = 100
@export var slide_friction = .7

func update(delta):
	slide_movement(delta)
	if Player.get_next_to_wall() == null:
		return STATES.FALL
	if Player.get_next_to_wall() == Vector2.LEFT:
		Player.last_direction = Vector2.RIGHT
	if Player.get_next_to_wall() == Vector2.RIGHT:
		Player.last_direction = Vector2.LEFT
		
	if Player.is_on_floor() and (Player.movement_input.x == 0):
		return STATES.IDLE
	if Player.is_on_floor() and (Player.movement_input.x != 0):
		return STATES.MOVE
		
	if Player.jump_input_actuation == true and Player.can_jump == true:
		return STATES.JUMP  
	if Player.dash_input and Player.can_dash:
		return STATES.DASH
	
	return null

func slide_movement(delta): 
	if Player.climb_input:
		if Player.movement_input.y < 0:
			Player.velocity.y = -climb_speed
		elif Player.movement_input.y > 0:
			Player.velocity.y = climb_speed
		else: 
			Player.velocity.y = 0
	else:
		player_movement()
		Player.gravity(delta)
		Player.velocity.y *= slide_friction

func enter_state():
	pass
