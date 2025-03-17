extends RigidBody2D

var SPEED : float = 300
var objects_still_in_area : Array[Node2D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if $RayCastRight.is_colliding():
		linear_velocity.x = -SPEED
	elif $RayCastLeft.is_colliding():
		linear_velocity.x = SPEED
	
	if $RayCastDown.is_colliding():
		apply_central_impulse(Vector2(0,-100))
		
	for body in objects_still_in_area:
		body.hit(global_position)

func _on_area_2d_body_entered(body: Node2D) -> void:
	objects_still_in_area.append(body)
func _on_area_2d_body_exited(body: Node2D) -> void:
	objects_still_in_area.erase(body)
