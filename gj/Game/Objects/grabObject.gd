extends RigidBody3D

signal whiplashed(hit_pos:Vector3,velMouse)
signal hooked(mosueVel:Vector2,playerPos:Vector3)
var direction := Vector3.ZERO
var MouDir 
var MouVel 
var ImpDir
# Called when the node enters the scene tree for the first time.
func _init() -> void:
	self.whiplashed.connect(on_whiplashed,CONNECT_REFERENCE_COUNTED)
	self.hooked.connect(on_hooked,CONNECT_REFERENCE_COUNTED)

func on_whiplashed(pos_player):
	var impulse = Vector2(pos_player.x-position.x,pos_player.z-position.z).normalized()
	impulse *= -1;
	apply_impulse(Vector3(impulse.x,0,impulse.y))
	
	pass

func on_hooked(posPla,posImp,force):
	#var MouVel = Input.get_last_mouse_velocity().length()
	var pos = (posImp-self.position).normalized();
	var impulse = (posPla-self.position).normalized()*force
	#ImpDir *= abs(MouVel/10);
	apply_impulse(impulse,pos)
	
	#if MouVel >
	
	pass
