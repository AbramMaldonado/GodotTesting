extends "state.gd"

@onready var CoyoteTimer = $CoyoteTimer
@export var coyote_duration = 0.5 
var coyote_jump = false

func update(delta): 
	Player.gravity(delta)
	player_movement() 
	if Player.is_on_floor():
		return STATES.IDLE
	if Player.is_on_floor() and (Player.movement_input.x != 0):
		return STATES.IDLE
	if Player.jump_input_actuation and Player.can_jump and coyote_jump == true:
		return STATES.JUMP 
	if Player.dash_input and Player.can_dash:
		return STATES.DASH
	if Player.get_next_to_wall() != null:
		return STATES.SLIDE
	
	return null

func enter_state():
	if Player.prev_state == STATES.IDLE or Player.prev_state == STATES.MOVE or Player.prev_state == STATES.DASH: 
		coyote_jump = true
		CoyoteTimer.start(coyote_duration)
	
func _on_coyote_timer_timeout():
	coyote_jump = false
