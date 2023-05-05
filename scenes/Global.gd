extends Node

var dinero = 0

signal update_dinero

func _ready():
	pass
	
func dinero(d):
	dinero +=d
	emit_signal("update_dinero",dinero)
