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
	head.freeMove = true
	pass
	
func exit():
	head.freeMove = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.


func physics_update(_delta: float):
	if !Input.is_action_pressed("crouch"):
		transition.emit(self,"walking")
	pass
