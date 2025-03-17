extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Engine.time_scale = 0.5
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body == %Player:
		$Timer.start()
		print("womp womp")


func _on_timer_timeout() -> void:
	%Player.kill()
	get_tree().reload_current_scene()
