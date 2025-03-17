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
	
	move_and_collide(get_gravity() * delta)
		
	if $RayCastRight.is_colliding():
		position.x += -SPEED * delta
		print("position1:", position)
	elif $RayCastLeft.is_colliding():
		position.x += SPEED * delta
		print("position2:", position)
		
	if is_on_floor():
		print("is on floor")
		position.y -= 2000 * delta
		print("position3:", position)
		
	for body in objects_still_in_area:
		body.hit(global_position)
	
	print(position)
	print(global_position)
	

func is_on_floor():
	$RayCastDown.is_colliding()

func _on_area_2d_body_entered(body: Node2D) -> void:
	objects_still_in_area.append(body)
func _on_area_2d_body_exited(body: Node2D) -> void:
	objects_still_in_area.erase(body)
