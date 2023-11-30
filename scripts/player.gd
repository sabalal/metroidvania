extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -600.0
var health = 3
var isAlive = true
var hasSword = false
var swordPosition
var isAttacking = false
var attackAnimationCounter = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# For animating the player
@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D

@onready var healthUI = $"../UI/Control/MarginContainer/Label/Health"
@onready var death_screen = $"../UI/Control/MarginContainer/DeathScreen"

@onready var start_position = transform

@onready var collectibles = $"../Collectibles"
@onready var enemies = $"../Enemies"

func _ready():
	death_screen.hide()
	swordPosition = $"../Sword".transform

func _physics_process(delta):
	# Attack
	if hasSword && Input.is_action_just_pressed("attack"):
		attack()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if isAlive:
		var direction = Input.get_axis("left", "right")
		update_animations(direction)
			# Handle Jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		if direction != 0:
			switch_direction(direction)

	move_and_slide()
	
func update_animations(horizontal_direction):
	if is_on_floor() && not isAttacking:
		if horizontal_direction == 0:
			ap.play("idle")
		else:
			ap.play("run")
	elif not isAttacking:
		if velocity.y < 0:
			ap.play("jump")
		elif velocity.y > 0:
			ap.play("fall")
			
func switch_direction(horizontal_direction):
	if sprite.flip_h != (horizontal_direction == -1):
		sprite.flip_h = (horizontal_direction == -1)

		if horizontal_direction == -1:
			$HitBox.scale.x = -1
		else:
			$HitBox.scale.x = 1

	sprite.position.x = horizontal_direction * 4
	
func disable_controls():
	isAlive = false
	ap.play("death")
	velocity.x = 0
	death_screen.show()
	
func hurt():
	# Update player UI
	healthUI.get_child(health * 2).hide()

func respawn():
	# Hide the death screen
	death_screen.hide()
	# Set the player state to alive
	isAlive = true
	# Set the transform to the starting positiondddddddddddd
	transform = start_position
	# Set health to max
	replenish_health()
	# Reset the sword
	var sword = preload("res://scenes/sword.tscn").instantiate()
	get_parent().add_child(sword)
	sword.transform = swordPosition
	hasSword = false

func replenish_health():
	health = 3
	# Update the health ui
	var hearts = healthUI.get_children()
	for heart in hearts:
		heart.show()

func attack():
	if not isAttacking:
		isAttacking = true
		$AttackTimer.start()
		if attackAnimationCounter == 0:
			ap.play("attack_1")
			attackAnimationCounter += 1
		elif attackAnimationCounter == 1:
			ap.play("attack_2")
			attackAnimationCounter = 0

func _on_death_trigger_body_entered(body):
	body.disable_controls()

func _on_attack_timer_timeout():
	isAttacking = false

func init_collectibles():
	pass

func init_enemies():
	pass
