extends KinematicBody2D

const ACCEL = 500
const MAX_SPEED = 80
const FRICTION = 500
var fish=false
var tiempo = 0
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
			
		tiempo = 0
		fish=false
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		if fish == false:
			state_machine.travel("RESET")
			tiempo += delta
			if tiempo >= 10:
				state_machine.travel("idle")

		
	if Input.is_action_just_pressed("click_left_fish"):
		tiempo = 0
		var click_pos = get_global_mouse_position()
		var player_pos = global_position
		
		var direction = click_pos - player_pos
		direction = direction.normalized()
		
		if direction.x > 0.5:
			if fish == true:
				state_machine.travel("recoger_pescar_derecha")
				$tiempo_espera.stop()
				fish=false
			else:
				fish=true
				#print(get_global_mouse_position())
				state_machine.travel("pescar_derecha")
		elif direction.x < -0.5:
			if fish == true:
				state_machine.travel("recoger_pescar_izquierda")
				$tiempo_espera.stop()
				fish=false
			else:
				fish=true
				#print(get_global_mouse_position())
				state_machine.travel("pescar_izquierda")
		elif direction.y > 0.5:
			if fish == true:
				state_machine.travel("recoger_pescar_abajo")
				$tiempo_espera.stop()
				fish=false
			else:
			# Si la animación no se ha utilizado antes, reproducela normalmente
				fish=true
				#print(get_global_mouse_position())
				state_machine.travel("pescar_abajo")
		elif direction.y < -0.5:
			if fish == true:
				state_machine.travel("recoger_pescar_arriba")
				$tiempo_espera.stop()
				fish=false
			else:
				fish=true
				#print(get_global_mouse_position())
				state_machine.travel("pescar_arriba")


	velocity = move_and_slide(velocity)





func _on_fish_body_entered(body):
	#print("pescando")
	#print(body.collision_layer,"-",body.collision_mask)
	if(body.collision_layer==16 and body.collision_mask==32):
		state_machine.travel("error_pesca")
	if(body.collision_layer==5 and body.collision_mask==9):
		$tiempo_espera.start()
		
		
	
	pass 
	

func _on_tiempo_espera_timeout():
	if fish==true:
		Global.dinero(randi() % 10 + 3 )
	#fish=false
	state_machine.travel("pesca_exitosa")
	$tiempo_espera.stop()
	
	pass

