class_name HurtBox
extends Area2D

func _on_area_entered(hit_box: HitBox):
	print("hit detected")
	if hit_box == null:
		return
	
	if owner.has_method("take_damage"):
		owner.take_damage(hit_box.damage)
