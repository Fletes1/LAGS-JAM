extends RigidBody3D

signal applyImpulse

func _init() -> void:
	self.applyImpulse.connect(on_applyImpulse,CONNECT_REFERENCE_COUNTED)
	

func on_applyImpulse(posPla,posImp,force):
	##Debe ser normalizado para queno agarre valores mas alla de su alcance
	var pos = (posImp-self.position).normalized();
	##agarra la posicion de donde se encgancha el latigo, luego lo resta con si propia posicion para sacar la posicion final, que es la posicion de dedonde va a surgir el impulso
	var impulse = (posPla-self.position).normalized()*force##Calcula primero la direccion del jugador al restar su propias psocion con la de ljugaor, despues de eso se le aplica la fuerza de impulso
	#ImpDir *= abs(MouVel/10);
	apply_impulse(impulse,pos) 
	#aplicamos el impulso al objeto
