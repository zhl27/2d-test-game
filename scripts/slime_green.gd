extends CharacterBody2D

@export_category("Movement")
@export var h_acceleration : float = 12000 # si se multiplica por delta, el valor es igual a px/segundo
@export var jump_acceleration : float = -15000 # for jumping
@export var horizontal_dampening : float = 0.05

var do_jump : bool = false
var do_hit : bool = false # it does not attack immediately after waking up

@export_category("Cooldowns")
@export var jump_cooldown : float = 3 # in seconds
@export var hit_cooldown : float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$JumpCoolDown.autostart = true
	$HitCoolDown.autostart = true
	
	add_to_group("Enemies")
	
	$DamageArea.monitoring = false
	$RayCastRight.enabled = false 
	$RayCastLeft.enabled = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if not is_on_floor(): # if is on floor, then jump
		velocity += get_gravity() * delta # apply gravity
	elif do_jump:
		jump_around(delta)
	
	if do_hit:
		attack()
	
	velocity.x = velocity.x * (1 - horizontal_dampening) 
	
	move_and_slide()


#region Behaviour

func attack(): # pick one player in DamageArea and hit it
	var player : CharacterBody2D = get_tree().get_nodes_in_group("players_still_in_area").pick_random()
	if player: # if there is any...
		player.hit_from(global_position)
	do_hit = false
	$HitCoolDown.start()

func jump_around(delta):	
	do_jump = false
	$JumpCoolDown.start()
	if $RayCastRight.is_colliding() or $RayCastLeft.is_colliding(): # change direction when colliding
		h_acceleration = -h_acceleration
	else:
		h_acceleration = randf_range(h_acceleration*0.75, h_acceleration)
	velocity.x += h_acceleration * delta
	velocity.y += jump_acceleration * delta

func wake_up():
	$DamageArea.monitoring = true
	$AnimatedSprite2D.play("idle") 
	$RayCastRight.enabled = true 
	$RayCastLeft.enabled = true
	
	return 0 # for the await 
	
#endregion


#region Signal Callbacks

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.add_to_group("players_still_in_area")
func _on_area_2d_body_exited(body: Node2D) -> void:
	body.remove_from_group("players_still_in_area")

func _on_jump_time_timeout() -> void:
	do_jump = true
func _on_hit_cool_down_timeout() -> void:
	do_hit = true
	
#endregion
