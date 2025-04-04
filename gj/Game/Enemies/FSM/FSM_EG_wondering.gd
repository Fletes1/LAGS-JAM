extends State

@onready var head : Node3D
@onready var navAgent : NavigationAgent3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	head=get_parent().get_parent()
	navAgent = head.get_node("NavigationAgent3D")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#luego lo armo bien, por ahora primero la vida y salud
	#if navAgent.is_target_reached() or !navAgent.target_position or !navAgent.is_target_reachable():
		#print("aaa")
		#var random_position = Vector3.ZERO
		#var actual_position = head.position
		#random_position.x = randf_range(actual_position.x-5.0,actual_position.x+5.0)
		#random_position.z = randf_range(actual_position.z-5.0,actual_position.z+5.0)
		#navAgent.set_target_position(random_position)
