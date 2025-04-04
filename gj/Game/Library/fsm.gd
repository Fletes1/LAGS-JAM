extends State

#ESTE NODO NO SE DEBE DE TOCAR JAMAS, DEPENDE DEMASIADO DE PUNTERO Y EL CUERPO JUNTOS
##LO MEJOR QUE PUEDES HACER ES LIMITARTE A "N O  T O C A R" ESTE NODo POR NADA

@export var initial_state : State

var current_state : State
var states : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transition.connect(_on_child_transition)
	if initial_state:
		initial_state.enter()
		current_state = initial_state
	pass 

func _process(_delta: float) -> void:
	
	if current_state:
		current_state.update(_delta);
	pass

func _physics_process(_delta: float) -> void:
	if current_state:
		current_state.physics_update(_delta);
	pass

func _on_child_transition(state:State,new_state_name:String):
	if state != current_state:
		return
		
	var new_state =states.get(new_state_name.to_lower())
	if !new_state:
		return
		
	if current_state:
		current_state.exit()
	new_state.enter()
	
	current_state = new_state
	pass
