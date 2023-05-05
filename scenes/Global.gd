extends Node

var dinero = 0

signal update_dinero

func _ready():
	pass
	
func dinero():
	dinero +=1
	emit_signal("update_dinero",dinero)
