extends CharacterBody3D

@onready var cursor = $Cursor
@onready var body = $FSM_Movement

func _ready() -> void:
	Input.mouse_mode=Input.MOUSE_MODE_HIDDEN

func _physics_process(_delta: float) -> void:
	cursor.physics_update(_delta);
	body.physics_update(_delta);
	
