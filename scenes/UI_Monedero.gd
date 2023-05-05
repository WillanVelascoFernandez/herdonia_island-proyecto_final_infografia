extends CanvasLayer

func _ready():
	Global.connect("update_dinero", self, "update_dinero_ui")
	$Monedero/Dinero.text="$" + "0"
	pass 
func update_dinero_ui(dinero):
	$Monedero/Dinero.text ="$" +  str(dinero)
