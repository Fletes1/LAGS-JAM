extends CharacterBody3D

#Sight
#
#var=Player
#
#move
#
#FSM Personalizados
#investigacion,
#Preparacion, 
#Ataque,
#Vulnerable,
#Desarmado

##PRIMERO LA FORMA DE MATARLO Y DESPUES LA FORMA EN QUE ME MATA
var hitPoints=3


signal applyWhiplash

@onready var navAgent : NavigationAgent3D= $NavigationAgent3D
@onready var FSM = $FSM

func _init() -> void:
	self.applyWhiplash.connect(_on_applyWhiplash,CONNECT_REFERENCE_COUNTED)

func _process(delta: float) -> void:
	if hitPoints == 0:
		queue_free()

func _physics_process(_delta: float) -> void:
	var destination = navAgent.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination .normalized()
	velocity = direction * 5.0
	move_and_slide()


func _on_applyWhiplash() -> void:
	hitPoints-=1
	#health-=abs(force)
	pass # Replace with function body.
