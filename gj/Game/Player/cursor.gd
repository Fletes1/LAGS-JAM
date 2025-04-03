extends Node3D

@onready var camera
@onready var head
var cursor

var posHook : Vector3
var dirHook : Vector3

var noAction = true
var refTime = 0.0

var contBody : Object
var objHook : Object
var firstPos = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cursor = self
	head = get_parent()
	camera = head.get_node("Pivot/Torque/Camera3D")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(_delta: float) -> void:
	var ray = createRay()
	useRay(ray)
	if Input.is_action_pressed("mouseLeft") and noAction:
		refTime += _delta
		if refTime > 0.05:
			hookObjective();
	if Input.is_action_just_released("mouseLeft"):
		if refTime <= 0.09 and noAction:
			makeSingleShot(-10);
		refTime=0.0
		noAction=true
	pass

func useRay(intersection:Dictionary):
	if intersection:
		if not intersection.is_empty():
			var pos = intersection.position
			contBody = intersection.collider
			self.global_position = pos
	else:
		self.global_position = Vector3.ZERO

func createRay():
	var space_state = get_world_3d().direct_space_state
	var mouse_position =get_viewport().get_mouse_position()
	var rayOrigin = camera.project_ray_origin(mouse_position)
	var rayEnd = rayOrigin + camera.project_ray_normal(mouse_position) * 2000
	var query = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd, 0xFFFFFFFF, [get_parent().get_rid()])
	var intersection = space_state.intersect_ray(query)
	return intersection


func hookObjective():
	if !objHook:
		if contBody.is_in_group("Objetos"):
			#makeSingleShot(1)
			objHook=contBody
		elif contBody.name =="StaticBody3D":
			objHook=get_parent()
			pass
		elif contBody.is_in_group("Enemigos"):
			#makeSingleShot(1)
			objHook=get_parent()
		else:
			pass
		#Agarra el objet orecien seleccionado,
		posHook=cursor.global_position
		
		#al igual que la posiicon original
		firstPos= get_viewport().get_mouse_position() #Agarra el angulo iinicial de dondefue agarrrado en relacion con la pantalla "viewport" otnendiendo los datos en un vector 2D
		#agarra la ultima velocidad registradaa del mouse en un vector 2D, luego obtiene la longitud final de ese valor
	print(firstPos,get_viewport().get_mouse_position())	
	if (firstPos - get_viewport().get_mouse_position()).length() > 50 :
		
		var velMouse = min(Input.get_last_mouse_velocity().length(),50)
		print(velMouse)
		#print((Input.get_last_mouse_screen_velocity() - firstPos).length())
		var angleDif = (Input.get_last_mouse_screen_velocity() - firstPos).angle_to(firstPos*-1) ##Obtiene el angulo entre la ultima posicion del mouse y el punto de origen
		print(angleDif)
		velMouse*=(1-(min(angleDif,90)/90))
		if contBody.is_in_group("Enemigos"):#altera la velocidad pero no la direccion, para que se a mas facil apuntar al enemigo
			objHook.emit_signal("applyImpulse",get_parent().position,posHook,velMouse)
		else:#altera la direccion a la que va
			objHook.emit_signal("applyImpulse",get_parent().position,posHook,velMouse)
		objHook=null
		noAction = false
	pass


func makeSingleShot(force):
	if contBody.is_in_group("Objetos"):
		contBody.emit_signal("applyImpulse",get_parent().position,global_position,force)
	elif contBody.name=="StaticBody3D":
		get_parent().emit_signal("applyImpulse",get_parent().position,global_position,force)
		pass
	elif contBody.is_in_group("Enemigos"):
		contBody.emit_signal("applyWhiplash",force)
	else:
		pass
		#print(contBody.name,StaticBody3D,contBody.name=="StaticBody3D")
		#get_parent().emit_signal("applyImpulse",get_parent().position,position,1)
	pass # Replace with function body.


		#print(Input.get_last_mouse_velocity(),firstPos)
		#(Input.get_last_mouse_screen_velocity() - firstPos)
		#diferencia de vector entre posicion enganchado y posicion actual
		#Lo qeu da el vector que da la distancia entre el ultimo y el inicial
		#ahora, la distancia no esta del todo hecha, necesita ser añadida con una multiplicacion
		
		#Podriamos solo aplicar un Angle_to para que simplemente nos de el vector que mire hacia 
		#firstPosse.angle_to
		
		
		#(input.get_last_mouse_screen_velocity - firstPos)
		#Obtenemos el vector de distancia (N) entre el primero y el segundo con referencia a X
		
		#(input.get_last_mouse_screen_velocity - firstPos)*angle_to(firstPos*-1)
		#usamos el vector (N) y aplicamos la funcion angle_to sobre el vector dep rimera poscion invertida, para que tenga relacion con X
		#y asi, obtener el angulo de diferencia entre la posicion inicial y la final para poder sacar el angulo entre el primero y el fina
		#esto servira como un metodo para saber si el objeto esta realmente jalando o  aflojando, si sobrepasa a 45 grados (+o-) ya no jala bien, si sobrepasa los 90, directametne no esta jalando.
		#angleDif = (input.get_last_mouse_screen_velocity - firstPos)*angle_to(firstPos*-1) < 90 ##ESTA JALANDO
		#Tambien se puede aprvechar este elemento para alterar la direccion del impulso, y asi darle mas control sobre el objeto
		#
		
		#aunque en ese sentido, no seria lo mismo que hacer simplemente (input.get_last_mouse_screen_velocity.angle_to()
		#no, por que es dependiente de X, si llega a hacer rapidamente de izquierda superior a derecha inferior, la jalada lo contara como aflojada y no hara efecto
		#solo se puede hacer bien si en primer lugar, ambos valores no pueden depender.
		#Este metodo es "CASI" infalible para saber si esta jalando o no
		
		#aunque lo que necesitamos es la distancia 
		
		#Input.get_last_mouse_screen_velocity().length - firstPos.length
		#distancia entre la ultima posicion del primero mouse y distancia de la primer posicion
		#si da negativo, esta jalando, si da positivo, esta aflojand
		
		#Esto puede ser facilmente destruible aplicandolo al suelo, no es factible este metodo de verificacion
		
	 # Replace with function body.
