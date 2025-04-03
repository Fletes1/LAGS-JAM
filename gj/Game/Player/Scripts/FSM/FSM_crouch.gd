extends State

@onready var head : Node3D
@onready var collision : CollisionShape3D

var baseValues : Dictionary

var timeRef := 0.0
func _ready() -> void:
	head=get_parent().get_parent()
	collision=head.get_node("CollisionShape3D")
	baseValues["speed"]=head.speed
	baseValues["jump"]=head.jump
	pass

func enter():
	head.speed = baseValues.speed/3
	head.onAir = false
	#head.collision.rotate_x(45)
	pass
	
func exit():
	#head.collision.rotate_x(-45)
	pass


func physics_update(_delta: float):
	if Input.is_action_just_released("crouch"):
		self.emit_signal("transition",self,"IDLE")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(_delta: float):
	pass
