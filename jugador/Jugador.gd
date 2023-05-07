extends KinematicBody2D

const ACCEL = 500
const MAX_SPEED = 80
const FRICTION = 500
var fish=false
var tiempo_idle = 0
var orientacion_pesca = ""
var velocity = Vector2.ZERO

onready var state_machine = $AnimationTree.get("parameters/playback")


func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	#print(input_vector)
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCEL * delta)
		if velocity.x < 0:
			state_machine.travel("caminar_izquierda")
		elif velocity.x > 0:
			state_machine.travel("caminar_derecha")
		elif velocity.y < 0:
			state_machine.travel("caminar_arriba")
		elif velocity.y > 0:
			state_machine.travel("caminar_abajo")
			
		tiempo_idle = 0
		fish=false
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		if fish == false:
			state_machine.travel("RESET")
			tiempo_idle += delta
			if tiempo_idle >= 10:
				state_machine.travel("idle")

		
	if Input.is_action_just_pressed("click_left_fish"):
		tiempo_idle = 0
		var click_pos = get_global_mouse_position()
		var player_pos = global_position
		
		var direction = click_pos - player_pos
		direction = direction.normalized()
		
		if direction.x > 0.5:
			if fish == true:
				if $tiempo_captura.time_left<=2 && $tiempo_captura.time_left>0:
					Global.aumentar_dinero(randi() % 10 + 3 )
				state_machine.travel("recoger_pescar_derecha")
				fish=false
			else:
				fish=true
				state_machine.travel("pescar_derecha")
				orientacion_pesca = "derecha"
		elif direction.x < -0.5:
			if fish == true:
				if $tiempo_captura.time_left<=2 && $tiempo_captura.time_left>0:
					Global.aumentar_dinero(randi() % 10 + 3 )
				state_machine.travel("recoger_pescar_izquierda")
				fish=false
			else:
				fish=true
				state_machine.travel("pescar_izquierda")
				orientacion_pesca = "izquierda"
		elif direction.y > 0.5:
			if fish == true:
				if $tiempo_captura.time_left<=2 && $tiempo_captura.time_left>0:
					Global.aumentar_dinero(randi() % 10 + 3 )
				state_machine.travel("recoger_pescar_abajo")
				fish=false
			else:
				fish=true
				state_machine.travel("pescar_abajo")
				orientacion_pesca = "abajo"
		elif direction.y < -0.5:
			if fish == true:
				if $tiempo_captura.time_left<=2 && $tiempo_captura.time_left>0:
					Global.aumentar_dinero(randi() % 10 + 3 )
				state_machine.travel("recoger_pescar_arriba")
				fish=false
			else:
				fish=true
				state_machine.travel("pescar_arriba")
				orientacion_pesca = "arriba"


	velocity = move_and_slide(velocity)
	#print($tiempo_espera.time_left)





func _on_fish_body_entered(body):
	if(body.collision_layer==16 and body.collision_mask==32):
		state_machine.travel("error_pesca")
	if(body.collision_layer==5 and body.collision_mask==9):
		$tiempo_espera.start()
		
	

func _on_tiempo_espera_timeout():
	if orientacion_pesca == "derecha":
		state_machine.travel("pescar_derecha_exitosa")
	if orientacion_pesca == "izquierda":
		state_machine.travel("pescar_izquierda_exitosa")
	if orientacion_pesca == "abajo":
		state_machine.travel("pescar_abajo_exitosa")
	if orientacion_pesca == "arriba":
		state_machine.travel("pescar_arriba_exitosa")
	
	$tiempo_espera.stop()
	$tiempo_espera.wait_time=rand_range(2,12)
	$tiempo_captura.start()


func _on_tiempo_captura_timeout():
	state_machine.travel("error_pesca")
	$tiempo_captura.stop()
