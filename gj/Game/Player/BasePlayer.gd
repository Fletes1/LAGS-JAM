extends RigidBody3D


signal MouseInp
signal MouseSus
signal applyImpulse

@onready var cursor = $Cursor
@onready var body = $FSM_Movement
@onready var pivot = $Pivot
@onready var detGround=$DetGround

@export var speed = 10
@export var jump = 30

var onAir : bool
var direction = Vector3.ZERO
var timeRef = 0.0
var delta

func _ready() -> void:
	Input.mouse_mode=Input.MOUSE_MODE_HIDDEN
	contact_monitor=true

#Explicacion visual de la rutina del
func _physics_process(_delta: float) -> void:
	delta=_delta
	cursor.physics_update(_delta);
	body.physics_update(_delta);
	indpendentMove(_delta)


#Comandos que son indendientes del movimiento
func indpendentMove(_delta:float):
	if Input.is_action_pressed("rotate_L"):
		pivot.rotate_object_local(Vector3(0,1,0),-2*_delta)
	elif Input.is_action_pressed("rotate_R"):
		pivot.rotate_object_local(Vector3(0,1,0),5*_delta)
	pivot.global_position=global_position
	
	timeRef+=_delta
	timeRef = int(Input.is_action_pressed("mouseLeft"))*(_delta+timeRef)
	if timeRef > 0.001:
		emit_signal("MouseSus");
	
	if Input.is_action_just_pressed("mouseLeft"):
		emit_signal("MouseInp")
		timeRef=_delta
	if detGround.is_colliding():
		detGround=true
	else:
		detGround=false
	pass

#Acceso directo al PhysicsDirectBodyState3D para mayor control del personaje
func _integrate_forces(state: PhysicsDirectBodyState3D):
	
	var inp_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var inp_jump = float(Input.is_action_just_pressed("ui_accept"))*speed
	
	direction = (pivot.transform.basis * Vector3(inp_dir.x,0, inp_dir.y)).normalized()
	
	
	#if FREE_MOV fall: el moviientocontrolado por computador
	#else: movimiento controlado por usuario
	#No sobrescribas el Linear_velocity "Y" o la gravedad deja de funcionar
	if direction:
		state.linear_velocity.x=direction.x*speed
		state.linear_velocity.z=direction.z*speed
	#XZ son controlados por el usario
	#Y (Gravedad) lo calcula la maquina
	#	state.linear_velocity = lerp(linear_velocity, Vector3.ZERO, speed)
	
	
	
	#el apply impulse se esta conectando al direction, pero me temo que por las prisas lo voy a dejar asi
	#Podria intentar multiplicar la gravedad a ver que sucede, duplicarla
	apply_impulse(Vector3(0,inp_jump,0))
	
	#print(inp_jump,"|",get_gravity(),"|",get_colliding_bodies(),"|",linear_velocity)

	#player.velocity = inpMov
	#print(Input.get_last_mouse_screen_velocity())


func _on_apply_impulse(player,posImp,force) -> void:
	##Debe ser normalizado para queno agarre valores mas alla de su alcance
	#var pos = (posImp-self.position).normalized();
	##agarra la posicion de donde se encgancha el latigo, luego lo resta con si propia posicion para sacar la posicion final, que es la posicion de dedonde va a surgir el impulso
	var impulse = (posImp-self.global_position).normalized()*force##Calcula primero la direccion del jugador al restar su propias psocion con la de ljugaor, despues de eso se le aplica la fuerza de impulso
	#ImpDir *= abs(MouVel/10);
	#print(impulse,force)
	apply_impulse(impulse) 
	pass # Replace with function body.
