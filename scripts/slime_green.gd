extends AnimatableBody2D

var SPEED : float = 300
var objects_still_in_area : Array[Node2D] = [] # It allows detection of more players, in case of multiplayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	constant_linear_velocity.x = randi_range(-200, 200)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	constant_linear_velocity += get_gravity() * delta
	
	if $RayCastRight.is_colliding():
		print("ray cast right")
		constant_linear_velocity.x = -SPEED
	elif $RayCastLeft.is_colliding():
		print("ray cast left")
		constant_linear_velocity.x = SPEED
	
	if is_on_floor():
		print("is on floor")
		constant_linear_velocity.y += 100 * delta
		
	for body in objects_still_in_area:
		body.hit(global_position)
	
	#print(constant_force)

func is_on_floor():
	$RayCastDown.is_colliding()

func _on_area_2d_body_entered(body: Node2D) -> void:
	objects_still_in_area.append(body)
func _on_area_2d_body_exited(body: Node2D) -> void:
	objects_still_in_area.erase(body)
