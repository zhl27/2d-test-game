extends Area2D

@onready var AnimatedSprite: AnimatedSprite2D = $"../AnimatedSprite2D"

#region Signal Callbacks

func _on_body_entered(_body: Node2D) -> void:
	print(self.get_parent().name+": zzzn't")
	AnimatedSprite.play("wake_up")
	await self.get_parent().wake_up()
	queue_free()
	
#endregion
