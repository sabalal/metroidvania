extends CharacterBody2D


const SPEED = 100.0
var dir = 1
@export var health = 3

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_taking_damage = false
var is_alive = true


func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_alive:
		velocity.x = SPEED * dir
		move_and_slide()

func _on_change_direction_body_entered(body):
	pass
	# body.dir = -1 * body.dir
	# body.sprite.flip_h = not body.sprite.flip_h


func _on_player_detection_body_entered(body):
	if body.name == "Player" && is_alive:
		hit(body)
		
func hit(body):
	if body.isAlive == true:
		body.health = body.health - 1
		body.hurt()
	
	if body.health <= 0:
		body.disable_controls()

func take_damage(damage):
	health -= damage
	if health > 0:
		ap.play("hurt")
	else:
		ap.play("death")
		death()
	is_taking_damage = true
	$DamageTimer.start()
	
func death():
	ap.play("death")
	is_alive = false

func _on_damage_timer_timeout():
	is_taking_damage = false
	if is_alive:
		ap.play("walk")
	else:
		queue_free()

func _on_player_detection_area_entered(area: Area2D):
	if area.get_collision_layer_value(6):
		dir = -1 * dir
		sprite.flip_h = not sprite.flip_h
