extends RigidBody2D

func _on_touch_area_area_entered(area):
	queue_free()
	Global.possition_ball = $".".position
	Global.collision_big.emit()
