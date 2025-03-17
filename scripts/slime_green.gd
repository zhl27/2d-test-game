extends RigidBody2D

var SPEED : float = 300


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if $RayCastRight.is_colliding():
		linear_velocity.x = -SPEED * delta
	elif $RayCastLeft.is_colliding():
		linear_velocity.x = SPEED * delta
	
	if $RayCastDown.is_colliding():
		apply_central_impulse(Vector2(0,-100))


func _on_area_2d_body_entered(body: Node2D) -> void:
	
	body.hit()
