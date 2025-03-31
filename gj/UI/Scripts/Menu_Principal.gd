extends Control

#Estos son las funciones de los primeros 3 botones del menu principal
#region 

func Comenzar_nivel() -> void:
	get_tree().change_scene_to_file("res://Game/Levels/Escenas/nivel_prueva.tscn")
	pass # Replace with function body.

func Opciones() -> void:
	$"../Camera2D".position.x += 1200
	pass # Replace with function body.


func SalirDelJuego() -> void:
	$Salir.position.y = 0
	pass # Replace with function body.
#endregion

#Estos son las funciones de los 2 botones de la pregunta si cerrar el juego
#region

func Salir_Aceptar() -> void:
	get_tree().quit()
	pass # Replace with function body.



func Salir_Cancelar() -> void:
	$Salir.position.y = 700
	pass # Replace with function body.
	
#endregion
