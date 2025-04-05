extends RigidBody3D

##Recuerdamente de cambiar la camara, no se mueva en los saltos, apuntar se hace
##complicado... pero eso esta bien?... esta mal?

signal applyImpulse

#AnimationMixer (at: Player.tscn): 'Armature|Armature|mixamo_com|Layer0', couldn't resolve track:  'Armature/Skeleton3D:mixamorig_RightHandThumb3'. This warning can be disabled in Project Settings.

@onready var cursor = $Cursor
@onready var FSM = $FSM_Movement
@onready var pivot = $Pivot
@onready var detGround=$DetGround
@onready var model3D=$Model3D

@export var speed = 10
@export var jump = 15

var freeMove : bool
var onGround : bool
var direction = Vector3.ZERO
var timeRef = 0.0

func _ready() -> void:
	Input.mouse_mode=Input.MOUSE_MODE_HIDDEN
	contact_monitor=true
	detGround.add_exception(self)

#Explicacion visual de la rutina del
func _physics_process(_delta: float) -> void:
	cursor.physics_update(_delta)
	indpendentMove(_delta)


#Comandos que son indendientes del movimiento
func indpendentMove(_delta:float):
	if Input.is_action_pressed("rotate_L"):
		pivot.rotate_object_local(Vector3(0,1,0),-2*_delta)
	elif Input.is_action_pressed("rotate_R"):
		pivot.rotate_object_local(Vector3(0,1,0),5*_delta)
	pivot.global_position=global_position
	if detGround.is_colliding():
		onGround=true
	else:
		onGround=false
	pass

#Acceso directo al PhysicsDirectBodyState3D para mayor control del personaje
func _integrate_forces(state: PhysicsDirectBodyState3D):
	
	var inp_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var inp_jump = Input.is_action_just_pressed("ui_accept")
	
	direction = (pivot.transform.basis * Vector3(inp_dir.x,0, inp_dir.y)).normalized()
	if direction:
		
		model3D.global_rotation.y=-(Vector2(model3D.position.x,model3D.position.z).angle_to(Vector2(direction.x,direction.z)));
	
	#if FREE_MOV fall: el moviientocontrolado por computador
	#else: movimiento controlado por usuario
	#No sobrescribas el Linear_velocity "Y" o la gravedad deja de funcionar
	
	
	if direction:
		state.linear_velocity.x=lerp(state.linear_velocity.x,direction.x*speed,1)
		state.linear_velocity.z=lerp(state.linear_velocity.z,direction.z*speed,1)
	if inp_jump and onGround:
		state.linear_velocity.y=float(inp_jump)*jump
	
	#XZ son controlados por el usario
	#Y (Gravedad) lo calcula la maquina
	#	state.linear_velocity = lerp(linear_velocity, Vector3.ZERO, speed)
	
	
	state.apply_impulse(Vector3.ZERO)
	#el apply impulse se esta conectando al direction, pero me temo que por las prisas lo voy a dejar asi
	#Podria intentar multiplicar la gravedad a ver que sucede, duplicarla
	


func _on_apply_impulse(_player,posImp,force) -> void:
	##Debe ser normalizado para queno agarre valores mas alla de su alcance
	#var pos = (posImp-self.position).normalized();
	##agarra la posicion de donde se encgancha el latigo, luego lo resta con si propia posicion para sacar la posicion final, que es la posicion de dedonde va a surgir el impulso
	var impulse = (posImp-self.global_position).normalized()*force##Calcula primero la direccion del jugador al restar su propias psocion con la de ljugaor, despues de eso se le aplica la fuerza de impulso
	
	if !onGround:
		apply_impulse(impulse) 
	pass # Replace with function body.
