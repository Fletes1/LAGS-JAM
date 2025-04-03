extends State

@onready var head : Node3D

var baseValues : Dictionary
var timeRef := 0.0

func _ready() -> void:
	head=get_parent().get_parent()
	baseValues["speed"]=head.speed
	baseValues["jump"]=head.jump
	pass
	
func enter():
	head.speed = baseValues.speed/4
	head.onAir = true
	pass
	
func exit():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.

func physics_update(_delta: float):
	if (head.linear_velocity.y < 0):
		transition.emit(self,"FALLING")
	pass


func update(_delta: float):
	pass
