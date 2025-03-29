extends Control

#  Estas variables de momento no la nescecitaremos pero 
#  cuando pongamos el menu durante el gameplay ayudara mucho
@export var EstaEnElMenuPrincipal: bool = true
@export var Camara: Camera2D



func Volver() -> void:
	Camara.position.x -= 1200
	pass # Replace with function body.
