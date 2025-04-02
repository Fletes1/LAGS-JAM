extends Node3D

@onready var camera = $Pivot/Torque/Camera3D
@onready var cursor = $Puntero

var posHook : Vector3
var dirHook : Vector3

var action := false
var _object : Object
var objHook : Object
var velMouse

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#camera = get_parent()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(_delta: float) -> void:
	var ray = createRay()
	useRay(ray)
	pass

func useRay(intersection:Dictionary):
	if intersection:
		if not intersection.is_empty():
			var pos = intersection.position
			_object = intersection.collider
			cursor.global_position = pos

func createRay():
	var space_state = get_world_3d().direct_space_state
	var mouse_position =get_viewport().get_mouse_position()
	var rayOrigin = camera.project_ray_origin(mouse_position)
	var rayEnd = rayOrigin + camera.project_ray_normal(mouse_position) * 2000
	var query = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd, 0xFFFFFFFF, [get_parent().get_rid()])
	var intersection = space_state.intersect_ray(query)
	return intersection

func _on_state_mouse_inp() -> void:
	if _object.is_in_group("Objetos"):
		_object.emit_signal("whiplashed",position)
	pass # Replace with function body.

func _on_state_mouse_sus():
	if _object.is_in_group("Objetos"):
		if !objHook:
			objHook=_object
			posHook=cursor.position
			var angHook= Input.get_last_mouse_screen_velocity().normalized()
		velMouse =(Input.get_last_mouse_velocity().length())
	if objHook!=_object and objHook!=null:
		objHook.emit_signal("hooked",get_parent().position,posHook,velMouse)
		objHook=null
		print(get_parent().position,posHook,velMouse)
		
	pass # Replace with function body.
	
