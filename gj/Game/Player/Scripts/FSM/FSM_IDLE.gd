extends State


@onready var head : Node3D

var timeRef := 0.0
func _ready() -> void:
	head=get_parent().get_parent()
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
	
func enter():
	head.speed = 10
	pass

	
func exit():
	pass


func physics_update(_delta: float):
	
	if Input.is_action_just_pressed("run"):
		self.emit_signal("transition",self,"run")
	if Input.is_action_pressed("crouch"):
		self.emit_signal("transition",self,"crouch")
	if !head.detGround and head.linear_velocity.y > 0:
		self.emit_signal("transition",self,"going_up")
	elif !head.detGround and head.linear_velocity.y < 0:
		self.emit_signal("transition",self,"going_up")
	pass
