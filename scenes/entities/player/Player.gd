extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")

#MOVEMENT
const SPEED = 200.0
const JUMP_VELOCITY = -400.0 

var last_direction = Vector2.RIGHT

#PLAYER INPUT
var movement_input = Vector2.ZERO
var jump_input = false #used to maintain jump velocity
var jump_input_actuation = false #Used to add input velocity
var climb_input = false
var dash_input = false

#MECHANICS
var can_dash = true
var can_jump = true
var stamina = 50

#STATE MANAGMENT
var current_state = null
var prev_state = null

#NODES
@onready var STATES = $STATES
@onready var Raycasts = $Raycasts 

func _ready(): 
	for state in STATES.get_children():
		state.STATES = STATES
		state.Player = self
	prev_state = STATES.IDLE
	current_state = STATES.IDLE

func _physics_process(delta): 
	player_input()
	change_state(current_state.update(delta))
	$Label.text = str(current_state.get_name())
	move_and_slide()
	
	if position.y > 500: game_over()
	
func gravity(delta):
	if not is_on_floor():
		velocity.y += gravity_value * delta
	print("velocity: ", velocity)
	
func change_state(input_state):
	if input_state != null:
		prev_state = current_state
		current_state = input_state
		
		prev_state.exit_state()
		current_state.enter_state() 
	
func get_next_to_wall(): 
	for raycasts in Raycasts.get_children():
		raycasts.force_raycast_update()
		if raycasts.is_colliding():
			if raycasts.target_position.x >0:
				return Vector2.RIGHT
			elif raycasts.target_position.x <0:
				return Vector2.LEFT
	return null
	
func player_input():
	movement_input = Vector2.ZERO #resetting input
	#MOVEMENT
	if Input.is_action_pressed("MoveRight"):
		movement_input.x += 1
	if Input.is_action_pressed("MoveLeft"):
		movement_input.x -= 1
	if Input.is_action_pressed("MoveUp"):
		movement_input.y -= 1
	if Input.is_action_pressed("MoveDown"):
		movement_input.y += 1
		
	#JUMP
	if Input.is_action_pressed("Jump"):
		jump_input = true
	else: 
		jump_input = false
	if Input.is_action_just_pressed("Jump"):
		jump_input_actuation = true
	else: 
		jump_input_actuation = false
	
	#CLIMB
	if Input.is_action_pressed("Climb"):
		climb_input = true
	else: 
		climb_input = false
		
	#DASH
	if Input.is_action_just_pressed("Dash"):
		dash_input = true
	else: 
		dash_input = false
	

func game_over():
	get_tree().reload_current_scene()
