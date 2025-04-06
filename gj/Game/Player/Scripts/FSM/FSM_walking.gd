extends State

@onready var animation = $"../../Model3D/AnimationPlayer"
@onready var head : Node3D
var baseValues : Dictionary

var timeRef := 0.0
func _ready() -> void:
	head=get_parent().get_parent()
	baseValues["speed"]=head.speed
	baseValues["jump"]=head.jump
	#animation.play("cooling")
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
	
func enter():
	head.speed = baseValues.speed
	head.jump = baseValues.jump
	animation.play("cooling")
	pass

	
func exit():
	pass


func physics_update(_delta: float):
	
	if Input.get_vector("ui_left","ui_right","ui_up","ui_down") and Input.is_action_pressed("run"):
		self.emit_signal("transition",self,"runing")
	elif !Input.get_vector("ui_left","ui_right","ui_up","ui_down"):
		self.emit_signal("transition",self,"idle")

	if !head.onGround:
		self.emit_signal("transition",self,"ON_AIR")
	pass
