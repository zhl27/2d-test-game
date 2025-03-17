extends Area2D

func _on_body_entered(body: Node2D) -> void:
	$"../AnimatedSprite2D".play("wake_up")

func _on_animated_sprite_2d_animation_finished() -> void:
	$".".queue_free()
	$"../DamageArea".monitoring = true
	$"../AnimatedSprite2D".play("idle")
