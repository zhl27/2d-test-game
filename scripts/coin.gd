extends RigidBody2D

#var floating_speed : float = 2.0
#var floating_magnitude : float = 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print("creado moneda")
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#Engine.time_scale = 0.05
	print(linear_velocity)
	if $RayCast2D.is_colliding():
		print("Collision")
		# do floating animation
		linear_velocity.y = 2000 * sin(Time.get_ticks_msec()/1000) * delta
	
	
		
	#if Time.get_ticks_msec() % 500 == 0:
		#print(position)
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == %Player:
		queue_free()
		
func picked_up():
	pass
