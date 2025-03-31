extends CharacterBody3D

var posHook : Vector3
var dirHook : Vector3

var rayOrigin = Vector3()
var rayEnd = Vector3()
var action := false
var _object : Object
var objHook : Object
var velMouse

@onready var camera = $Pivot/Node3D/Torque/Camera3D
@onready var cursorMesh = $Puntero

func _ready() -> void:
	Input.mouse_mode=Input.MOUSE_MODE_HIDDEN

func _physics_process(_delta: float) -> void:
	$FSM_Movement.update(_delta);
	var space_state = get_world_3d().direct_space_state
	var mouse_position =get_viewport().get_mouse_position()
	rayOrigin = camera.project_ray_origin(mouse_position)
	rayEnd = rayOrigin + camera.project_ray_normal(mouse_position) * 2000
	var query = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd, 0xFFFFFFFF, [get_rid()])
	var intersection = space_state.intersect_ray(query)
	if intersection:
		if not intersection.is_empty():
			var pos = intersection.position
			_object = intersection.collider
#			print(_object.node)
			
			#$Rig.look_at(Vector3(pos.x,position.y,pos.z), Vector3(0,1,0))
			cursorMesh.global_position = pos


func _on_state_mouse_inp() -> void:
	if _object.is_in_group("Objetos"):
		_object.emit_signal("whiplashed",position)
	pass # Replace with function body.

func _on_state_mouse_sus():
	if _object.is_in_group("Objetos"):
		if !objHook:
			objHook=_object
			var posHook=cursorMesh
			var angHook= Input.get_last_mouse_screen_velocity().normalized()
		velMouse =(Input.get_last_mouse_velocity().length())
	if objHook!=_object and objHook!=null:
		objHook.emit_signal("hooked",self.position,posHook,velMouse)
		objHook=null
		
		
	pass # Replace with function body.
	
