extends State

@onready var head : Node3D
var timeRef := 0.0
func _ready() -> void:
	head=get_parent().get_parent()
	pass
	
func enter():
	head.speed=20
	pass
	
func exit():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.

func physics_update(_delta: float):
	if Input.is_action_just_released("run"):
		self.emit_signal("transition",self,"IDLE")
	pass


func update(_delta: float):
	pass
