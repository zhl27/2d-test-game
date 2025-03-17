extends CharacterBody2D


const SPEED = 150.0
const JUMP_ACCELERATION = -20000.0

# coordinate system is positive downwards

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta # apply gravity
		#print(get_gravity())

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += JUMP_ACCELERATION * delta

	# direction: -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		$AnimatedSprite2D.play("run")
		velocity.x = direction * SPEED
		$AnimatedSprite2D.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.play("idle")

	move_and_slide() # update the position

func hit():
	$AnimatedSprite2D.play("take_damage")

func kill():
	print("PLUUHHHH !!!")
	$AnimatedSprite2D.play("death")
	

	
