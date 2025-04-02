class_name libState


class CursorState extends State:
	@onready var player : CharacterBody3D
	var inputs : Dictionary
	func _ready() -> void:
		player=get_parent().get_parent()
		pass # Replace with function body.
		
