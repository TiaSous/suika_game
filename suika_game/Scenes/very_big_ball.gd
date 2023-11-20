extends RigidBody2D

func _on_area_2d_area_entered(area):
	queue_free()
	Global.possition_ball = $".".position
	Global.collision_very_big.emit()
