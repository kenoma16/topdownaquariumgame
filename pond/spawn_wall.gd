extends Area2D

func _on_spawn_wall_body_entered(body):
	if not body.is_target:
		body.queue_free()