extends "state.gd"

func update(delta):
	Player.gravity(delta) 
	
	if Player.movement_input.x != 0:
		return STATES.MOVE
	if Player.velocity.y > 0:
		return STATES.FALL
	if Player.jump_input_actuation and Player.can_jump:
		return STATES.JUMP
	if Player.dash_input and Player.can_dash:
		return STATES.DASH
	if Player.climb_input and Player.get_next_to_wall() != null:
		return STATES.SLIDE
	return null

func enter_state():
	Player.can_jump = true
	Player.can_dash = true
