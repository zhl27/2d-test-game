extends CharacterBody2D

#enum States {IDLE, RUNNING, JUMPING, FALLING, ASLEEP, JUMP_CHARGING, JUMP_READY, ATTACK_CHARGING, ATTACK_READY}
#enum CooldownStates {CHARGING, READY}
#
#var current_state := States.IDLE | States.JUMP_CHARGING

# 4 (100) | 2 (010) = 6 (110)
# 0 (000) | 5 (101) = 5 # IDLE used in an operation results in the other operand state
# 

@export_category("Movement")
@export var h_acceleration : float = 12000 # si se multiplica por delta, el valor es igual a px/segundo
@export var jump_acceleration : float = -15000 # for jumping
@export var horizontal_dampening : float = 0.05

var is_awake : bool
var do_jump : bool
var do_hit : bool 
var players_in_damage_area : Array[Node2D]

@onready var JumpCoolDown: Timer = $JumpCoolDown
@onready var HitCoolDown: Timer = $HitCoolDown
@onready var DamageArea: Area2D = $DamageArea
@onready var RayCastRight: RayCast2D = $RayCastRight
@onready var RayCastLeft: RayCast2D = $RayCastLeft
@onready var AnimatedSprite: AnimatedSprite2D = $AnimatedSprite2D


@export_category("Cooldowns")
@export var jump_cooldown_time : float = 3 # in seconds
@export var hit_cooldown_time : float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print(current_state)
	is_awake = false
	do_hit = false # it does not attack immediately after waking up 
	do_jump = false
	players_in_damage_area = []
	
	JumpCoolDown.autostart = true
	HitCoolDown.autostart = true
	
	JumpCoolDown.wait_time = jump_cooldown_time
	HitCoolDown.wait_time = hit_cooldown_time
	
	add_to_group("Enemies")
	
	DamageArea.monitoring = false
	RayCastRight.enabled = false 
	RayCastLeft.enabled = false
	
	randomize()

func _physics_process(delta: float) -> void:
	
	self.velocity += get_gravity() * delta # apply gravity
	
	if is_awake:
		
		if is_on_floor() and do_jump:
			jump_around(delta)
			do_jump = false
			self.JumpCoolDown.start()
		
		if do_hit:
			attack()
			do_hit = false
			self.HitCoolDown.start()
		
		self.velocity.x = velocity.x * (1 - horizontal_dampening) 
	
	move_and_slide()


#region Behaviour

func attack(): # pick one player in DamageArea and hit it
	if players_in_damage_area.is_empty():
		return
		
	players_in_damage_area.pick_random().hit_from(global_position)


func jump_around(delta):
	# Change direction when about to hit a wall
	if RayCastRight.is_colliding():
		h_acceleration = -abs(h_acceleration)  # Force negative (left)
	elif RayCastLeft.is_colliding():
		h_acceleration = abs(h_acceleration)   # Force positive (right)
	else:
		# Add some randomness to movement
		var direction = 1 if randf() > 0.5 else -1
		h_acceleration = direction * h_acceleration
	
	velocity.x += h_acceleration * delta
	velocity.y += jump_acceleration * delta
	
	
func wake_up():
	DamageArea.monitoring = true
	AnimatedSprite.play("idle") 
	RayCastRight.enabled = true 
	RayCastLeft.enabled = true
	
	is_awake = true
	
	return 0# for the await 
	
#endregion


#region Signal Callbacks

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		players_in_damage_area.append(body)
func _on_area_2d_body_exited(body: Node2D) -> void:
	players_in_damage_area.erase(body)

func _on_jump_time_timeout() -> void:
	do_jump = true
func _on_hit_cool_down_timeout() -> void:
	do_hit = true
	
#endregion
