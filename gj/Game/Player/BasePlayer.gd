extends RigidBody3D


signal applyImpulse

@onready var cursor = $Cursor 		##Acceso al contro CURSOR, encargado del puntero y el latigo
@onready var body = $FSM_Movement 	##Acceso a las variables de movimiento, altera los valores segun el estado en el que este
@onready var pivot = $Pivot			##Acceso al pivote, Uso directo para cambiar la rotacion de la camara
@onready var detGround=$DetGround 	##Rayo colisionador, detecta si el usuario esta pisando el suelo, 
@onready var playerModel=$Model		##Acceso al modelo del personaje, 

@export var speed = 10.0 			##Velocidad de movimiento
@export var jump = 15.0 			##intensidad del Salto
@export var runEffect = 2.0 		##Multiplicador del efecto de salto
@export var crouchEffect = 0.2 		##Multiplicador del efecto de agacharse NOTA: No sobrepasar el 1.0
@export var airDirection = 0.1		##Intensidad de control sobre le movimiento en el aire
@export var whipLimitPower = 50.0 	##Potencia MAXIMA del latigo
@export var whipDeathZone = 50.0 	##Zona muerta de accion del latigo (en una circunferencia, whipDeathZone es el radio del limite)
@export var changeIntensity = 0.4	##Intensidad del cambio de velocidad o de estado (intensidad del derrape, cambio a agachado y demas)

var onAir : bool 				##Indica si el jugador esta en el aire
var onGround : bool 			##Verifica si el personaje este tocando el suelo
var direction = Vector3.ZERO  	##Valor vectoriano, Captura la direccion a la que deb ir el jugador
var timeRef = 0.0				##Contador que utiliza registra el tiempo 
var delta 						##delta improvisado

func _ready() -> void:
	Input.mouse_mode=Input.MOUSE_MODE_HIDDEN
	contact_monitor=true
	detGround.add_exception(self)
	self.applyImpulse.connect(_on_apply_impulse)

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
	
	if detGround.is_colliding():
		onGround = true
	else:
		onGround = false
	
	pass

#Acceso directo al PhysicsDirectBodyState3D para mayor control del personaje
func _integrate_forces(state: PhysicsDirectBodyState3D):
	
	var inp_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var inp_jump = int(Input.is_action_pressed("ui_accept"))
	inp_jump *= int(onGround); ##si esta en el suelo, anula el valor de salto
	
	direction = (pivot.transform.basis * Vector3(inp_dir.x,0, inp_dir.y)).normalized()
	if direction:
		playerModel.global_rotation.y = -(Vector2(playerModel.position.x,playerModel.position.z).angle_to(Vector2(direction.x,direction.z)))
	
	#if FREE_MOV fall: el moviientocontrolado por computador
	#else: movimiento controlado por usuario
	#No sobrescribas el Linear_velocity "Y" o la gravedad deja de funcionar
	
	
	
	if onAir:
		state.linear_velocity.x=lerp(state.linear_velocity.x,state.linear_velocity.x+direction.x,airDirection)
		state.linear_velocity.z=lerp(state.linear_velocity.z,state.linear_velocity.z+direction.z,airDirection)
	else:
		state.linear_velocity.x=lerp(state.linear_velocity.x,direction.x*speed,changeIntensity)
		state.linear_velocity.z=lerp(state.linear_velocity.z,direction.z*speed,changeIntensity)
	if inp_jump:
		state.linear_velocity.y=float(inp_jump)*jump
	
	#XZ son controlados por el usario
	#Y (Gravedad) lo calcula la maquina
	#	state.linear_velocity = lerp(linear_velocity, Vector3.ZERO, speed)
	
	
	
	#el apply impulse se esta conectando al direction, pero me temo que por las prisas lo voy a dejar asi
	#Podria intentar multiplicar la gravedad a ver que sucede, duplicarla
	apply_impulse(Vector3(0,0,0))
	
	#print(inp_jump,"|",get_gravity(),"|",get_colliding_bodies(),"|",linear_velocity)

	#player.velocity = inpMov
	#print(Input.get_last_mouse_screen_velocity())


func _on_apply_impulse(_player,posImp,force) -> void:
	##Debe ser normalizado para queno agarre valores mas alla de su alcance
	#var pos = (posImp-self.position).normalized();
	##agarra la posicion de donde se encgancha el latigo, luego lo resta con si propia posicion para sacar la posicion final, que es la posicion de dedonde va a surgir el impulso
	var impulse = (posImp-self.global_position).normalized()*force##Calcula primero la direccion del jugador al restar su propias psocion con la de ljugaor, despues de eso se le aplica la fuerza de impulso
	#ImpDir *= abs(MouVel/10);
	#print(impulse,force)
	if !onGround:
		apply_impulse(impulse) 
	pass # Replace with function body.
