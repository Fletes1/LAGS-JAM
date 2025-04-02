extends State

@onready var head : Node3D

var timeRef := 0.0
func _ready() -> void:
	head=get_parent().get_parent()
	pass
	
func enter():
	pass
	
func exit():
	pass


func physics_update(_delta: float):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(_delta: float):
	pass
