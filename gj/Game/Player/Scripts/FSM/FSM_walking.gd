extends State


@onready var head : Node3D
var baseValues : Dictionary

var timeRef := 0.0
func _ready() -> void:
	head=get_parent().get_parent()
	baseValues["speed"]=head.speed
	baseValues["jump"]=head.jump
	
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
	
func enter():
	head.speed = baseValues.speed
	head.jump = baseValues.jump
	
	pass

	
func exit():
	pass


func physics_update(_delta: float):
	
	if Input.is_action_just_pressed("run"):
		self.emit_signal("transition",self,"runing")
	if Input.is_action_pressed("crouch"):
		self.emit_signal("transition",self,"on_crouch")
	if !head.onGround and head.linear_velocity.y > 0:
		
		self.emit_signal("transition",self,"going_up")
	elif !head.onGround and head.linear_velocity.y < 0:
		
		self.emit_signal("transition",self,"falling")
	pass
