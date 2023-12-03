extends Area2D

func _on_area_entered(area):

	if area.owner.health < 3:
		area.owner.replenish_health()
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", self.position - Vector2(0, 75), 0.3)
		$AudioStreamPlayer2D.play()


func _on_audio_stream_player_2d_finished():
	queue_free()
