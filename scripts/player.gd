extends CharacterBody2D


const SPEED = 150.0
const JUMP_ACCELERATION = -20000.0

var coins_counter : int = 0


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("kill_player"):
		kill()

# coordinate system is positive downwards
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta # apply gravity
		#print(get_gravity())

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		$JumpSFX.play()
		velocity.y += JUMP_ACCELERATION * delta
	
	if Input.is_action_just_pressed("hit_player"):
		hit(Vector2(randi_range(-500, 500), randi_range(-100, -200)))

	# direction: -1, 0, 1
	var direction : float = Input.get_axis("move_left", "move_right")
	if direction:
		$AnimatedSprite2D.play("run")
		velocity.x = direction * SPEED
		$AnimatedSprite2D.flip_h = direction < 0
		if not $AnimatedSprite2D.is_playing():
			$AnimatedSprite2D.play("idle")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide() # update the position


func hit(from_where : Vector2):
	$HurtSFX.play()
	$AnimatedSprite2D.play("hurt")
	var direction : Vector2 = -global_position.direction_to(from_where) 
	velocity = direction * Vector2(1, 0.5) * 500


func kill():
	$DeathSFX.play()
	$AnimatedSprite2D.play("death")
	#$CollisionShape2D.queue_free()
	$RespawnCoolDown.start()
	Engine.time_scale = 0.5
	
	
func _on_respawn_cool_down_timeout() -> void:
	get_tree().reload_current_scene()
	Engine.time_scale = 1

func add_coin(num : int):
	coins_counter += num
func remove_coin(num : int):
	coins_counter -= num
	
 
