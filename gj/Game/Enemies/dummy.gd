extends CharacterBody3D

signal applyWhiplash
var health = 100

func _init() -> void:
	self.applyWhiplash.connect(_on_applyWhiplash,CONNECT_REFERENCE_COUNTED)
	

func _on_applyWhiplash(force) -> void:
	health-=abs(force)
	pass # Replace with function body.
