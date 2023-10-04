extends KinematicBody2D

export var acceleration := 500
export var max_speed := 100
export var friction := 1000

enum{
	MOVE,
	ROLL,
	ATTACK
}
var state = MOVE

#player velocity
var velocity = Vector2.ZERO

onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
# Called when the node enters the scene tree for the first time.
func _ready():
	animation_tree.active = true
	print("player ready")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if(input_vector != Vector2.ZERO):
		_set_blend_positions(input_vector)
		
		animation_state.travel("Run")		
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
	else:		
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	#returns acutal velocity with changes on slopes
	velocity = move_and_slide(velocity)
	
	#state transition
	if(Input.is_action_just_pressed("Attack")):
		velocity = Vector2.ZERO
		state = ATTACK

func roll_state(delta):
	pass
	
func attack_state(delta):
	animation_state.travel("Attack")

func attack_animation_finished():
	state = MOVE

func _set_blend_positions(input_vector):
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector)
