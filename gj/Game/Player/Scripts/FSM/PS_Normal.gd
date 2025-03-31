extends libState.PlayerState

signal MouseInp
signal MouseSus

var inpMov := Vector3.ZERO
var speed := 10

var timeRef := 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(delta: float):
	if not player.is_on_floor():
		inpMov += player.get_gravity() * delta
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and player.is_on_floor():
		inpMov.y = speed
	
	if Input.is_action_just_pressed("rotate_L"):
		player.rotation_degrees.y -= 45
	elif Input.is_action_just_pressed("rotate_R"):
		player.rotation_degrees.y += 45
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		inpMov.x = direction.x * speed
		inpMov.z = direction.z * speed
	else:
		inpMov.x = move_toward(inpMov.x, 0, speed)
		inpMov.z = move_toward(inpMov.z, 0, speed)
	player.velocity = inpMov
	#print(Input.get_last_mouse_screen_velocity())
	
	timeRef+=delta
	
	timeRef = int(Input.is_action_pressed("mouseLeft"))*(delta+timeRef)

	if timeRef > 0.001:
		emit_signal("MouseSus");
		
		
	if Input.is_action_just_pressed("mouseLeft"):
		emit_signal("MouseInp")
		timeRef=delta
	
	player.move_and_slide()
	pass
