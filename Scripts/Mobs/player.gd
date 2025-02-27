class_name Player
extends Mob

enum States {IDLE, DISSOCIATE, WALK, RUN, PICK_UP, HURT, ATTACK}

var state = States.IDLE
var animation = "idle"
var last_direction = "/down"

var is_running = false
var pick_up = false



func _ready() -> void:
	set_process_input(true)

func _input(event: InputEvent) -> void:
	direction = Vector2(Input.get_vector(&"ui_left", &"ui_right", &"ui_up", &"ui_down"))
	is_running = Input.is_action_pressed(&"ui_accept")
	if Input.is_action_pressed(&"attack"):
		pick_up = true


func  _physics_process(delta: float) -> void:
	move()


func _process(delta: float) -> void:
	states_machine()
	anim()
	camera()


func states_machine():
	#print(state)
#IDLE
	if state == States.IDLE:
		if $Dissociate.is_stopped():
			$Dissociate.wait_time = randf_range(5,10)
			$Dissociate.start()
		speed = 0
		animation = "idle"

		if direction:
			state = States.WALK
		elif is_running:
			state = States.RUN
		elif pick_up:
			state = States.PICK_UP

#DISSOCIATE
	elif state == States.DISSOCIATE:
		animation = "dissociate"


		if direction:
			state = States.WALK
		elif is_running:
			state = States.RUN
		elif pick_up:
			state = States.PICK_UP

#WALK
	elif state == States.WALK:
		animation = "walk"
		speed = 50

		if is_running:
			state = States.RUN
		elif !direction:
			state = States.IDLE
		elif pick_up:
			state = States.PICK_UP
#RUN
	elif state == States.RUN:
		animation = "run"
		speed = 100

		if !is_running:
			state = States.WALK
		elif !direction:
			state = States.IDLE
		elif pick_up:
			state = States.PICK_UP

#PICK_UP
	elif state == States.PICK_UP:
		animation = "pick_up"
		speed = 0

		if !pick_up:
			state = States.IDLE


	elif state == States.HURT:
		animation = "hurt"

	elif state == States.ATTACK:
		animation = "attack"

func camera():
	if direction:
		$Camera2D.drag_horizontal_offset = direction.x/2
		$Camera2D.drag_vertical_offset = direction.y/2


func anim():
	get_last_direction()
	$AnimationPlayer.play(animation+last_direction)

	if direction.x > 0:
		$Sprite2D.flip_h = true
	elif direction.x < 0:
		$Sprite2D.flip_h = false


func get_last_direction():
	if direction.x and direction.y > 0:
		last_direction = "/down_left"
	elif direction.x and direction.y < 0:
		last_direction = "/up_left"

	elif direction.x:
		last_direction = "/left"

	elif direction.y < 0:
		last_direction = "/up"
	elif direction.y > 0:
		last_direction = "/down"


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "pick_up"+last_direction:
		pick_up = false
	if anim_name == "dissociate"+ last_direction:
		state =States.IDLE


func _on_dissociate_timeout() -> void:
	state = States.DISSOCIATE
	print(state)
