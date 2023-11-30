extends Area2D



func _on_area_entered(area):

	if area.owner.health < 3:
		area.owner.replenish_health()
		queue_free()
