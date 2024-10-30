extends Area2D

func _process(_delta):
	position = $"../../SubViewportContainer2/SubViewport2/Camera3D".unproject_position(Globals.boss_body_pos)
	if Globals.is_moving:
		$CollisionShape2D.disabled = false
	else:
		$CollisionShape2D.disabled = true 


func _on_body_entered(body):
	if "hit" in body:
		body.hit()
