extends KinematicBody2D

enum PLAYER_STATE { IDLE, RUN }

export(float) var move_speed = 100

onready var sprite = $Sprite
onready var animation_tree = $AnimationTree
onready var state_machine = animation_tree.get("parameters/playback")

var current_state = PLAYER_STATE.IDLE setget set_current_state

func set_current_state(new_state):
	if(current_state != new_state):
		match(new_state):
			PLAYER_STATE.IDLE:
				state_machine.travel("idle")
			PLAYER_STATE.RUN:
				state_machine.travel("run")
	
		current_state = new_state

func _physics_process(delta):
	var input_xy = get_player_movement_input()
	
	var velocity = move_and_slide(input_xy * move_speed)
	
	# Picking the new state for the player
	if(velocity == Vector2.ZERO):
		self.current_state = PLAYER_STATE.IDLE
	else:
		self.current_state = PLAYER_STATE.RUN
	
	set_flip_direction(velocity)


func get_player_movement_input():
	var input_vector = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	return input_vector

func set_flip_direction(velocity : Vector2):
	if(velocity.x > 0):
		sprite.flip_h = false
	elif(velocity.x < 0):
		sprite.flip_h = true
