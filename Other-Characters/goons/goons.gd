extends CharacterBody2D

# Goons Variables
@export var SPEED = 15.0
const gravity = 350.0
@onready var Player: CharacterBody2D = get_parent().get_node("Player")
var direction
@export var attackRange: float = 220
var once: bool = true
@export var goonsHealth: int = 20

# Shooting Variables
var shoot_player: bool = false
@export var Bullet: PackedScene = preload("res://bullet.tscn")
var bullet
var canShoot: bool = true
@export var fireRate: float = 1.5

func _process(delta: float) -> void:
	#Gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if Player == null:
		if once:
			print_debug("Player Not Found!!")
			once = false
		return

	direction = Player.global_position.x - global_position.x
	# print(direction)
	if direction < attackRange:
		velocity.x = direction * SPEED * delta
		$AnimatedSprite2D.play("Moving")
		if not $Moving.playing:
			$Moving.playing = true
		if direction > 0:
			$AnimatedSprite2D.flip_h = false
			$CollisionShape2D.position.x = -0.5
			$ShootingRange/CollisionShape2D.position.x = 34.7
			$FiringPoint.position.x = 11.5
		else:
			$AnimatedSprite2D.flip_h = true
			$CollisionShape2D.position.x = 0.5
			$ShootingRange/CollisionShape2D.position.x = -34.7
			$FiringPoint.position.x = -11.5
	else:
		if $Moving.playing:
			$Moving.playing = false
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.play("default")

	if shoot_player:
		shoot()
	move_and_slide()

func shoot():
	if canShoot:
		bullet = Bullet.instantiate()
		get_node(".").add_child(bullet)
		bullet.transform = $FiringPoint.transform
		canShoot = false
		if not $Fire.playing:
			$Fire.playing = true
		$Timer.set_wait_time(fireRate)
		$Timer.start()

func OnHit(damange: int):
	goonsHealth -= damange
	if goonsHealth <= 0:
		queue_free()

func _on_shooting_range_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		shoot_player = true

func _on_shooting_range_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		shoot_player = false

func _on_timer_timeout() -> void:
	canShoot = true

# INFO:
# if you  want the enemey to stop when the player is behind or dir is in Negative use this direction > -attackRange.
# (e.g if direction > -attackRange and direction < attackRange)
# I Kept it due to when enemy spawn behind he will walk toward player automtically.
