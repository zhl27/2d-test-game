extends Area2D


#region Signal Callbacks

func _on_body_entered(body: Node2D) -> void:
	print("wake up !!!!")
	$"../AnimatedSprite2D".play("wake_up")
	await $"..".wake_up()
	$".".queue_free()
	
#endregion
