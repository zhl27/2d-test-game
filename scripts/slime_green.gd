extends AnimatableBody2D

@export_category("Movement")
@export var SPEED : float = 450 # si se multiplica por delta, el valor es igual a px/segundo

var objects_still_in_area : Array[Node2D] = [] # It allows detection of more players, in case of multiplayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("debug"): print(constant_linear_velocity)
	#print("delta:", delta)
	
	
	if $RayCastRight.is_colliding():
		if Input.is_action_just_pressed("debug"): print("ray cast right")
		constant_linear_velocity.x = -SPEED * delta
	elif $RayCastLeft.is_colliding():
		if Input.is_action_just_pressed("debug"): print("ray cast left")
		constant_linear_velocity.x = SPEED * delta
	
	if is_on_floor():
		print("is on floor")
		constant_linear_velocity.y = -2000 * delta
		
	for body in objects_still_in_area:
		body.hit(global_position)
	
	constant_linear_velocity += get_gravity() * delta
	
	#print(constant_force)
	move_and_collide(constant_linear_velocity)
	

func is_on_floor():
	$RayCastDown.is_colliding()

func _on_area_2d_body_entered(body: Node2D) -> void:
	objects_still_in_area.append(body)
func _on_area_2d_body_exited(body: Node2D) -> void:
	objects_still_in_area.erase(body)
