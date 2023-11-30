extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	# Update player state
	body.hasSword = true
	# Tween the sword
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", self.position - Vector2(0, 75), 0.2)
	# Remove the sword from the world
	tween.tween_callback(self.queue_free)
