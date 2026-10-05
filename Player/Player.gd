extends CharacterBody2D

@export var speed: float = 180.0
@export var gravity: float = 350.0
var move_direction
var can_intract : bool = false
@export var can_jump: bool = true
@export var jumpPower: float = 124.0
var isCrouching: bool = false
@export var canCrouch: bool = true
@export var PlayerHealth: int = 10
var canShoot: bool = true     #Cannot Shoot While Crouching
var shootAble: bool = true
@export var Bullet: PackedScene = preload("res://bullet2.tscn")
var bullet
@export var fireRate: float = 1.0
@export var GameOver: String = "res://Scenes/GameOver/game_over.tscn"

func shoot():
	if shootAble:
		bullet = Bullet.instantiate()
		get_node(".").add_child(bullet)
		bullet.transform = $FirePoint.transform
		shootAble = false
		if not $Fire.playing:
			$Fire.playing = true
		$Timer.set_wait_time(fireRate)
		$Timer.start()

func movement() -> void:
	#Shooting
	if canShoot and $PistoMini.visible:
		if Input.is_action_pressed("Shoot"):
			shoot()

	#Crouching
	if canCrouch:
		if Input.is_action_pressed("Crouch"):
			$AnimatedSprite2D.play("Crouching")
			isCrouching = true
			canShoot = false
			velocity.x = move_toward(move_direction, 0, speed)
		else:
			isCrouching = false
			canShoot = true

	if not isCrouching:
		$PistoMini.position.y = -7.4
		move_direction = Input.get_axis("Left", "Right")
		if move_direction:
			velocity.x = move_direction * speed
			$AnimatedSprite2D.play("Moving")
			$AnimatedSprite2D.scale.x = 1.0 if move_direction == 1 else -1.0
			$PistoMini.flip_h = false if move_direction == 1 else true
			$PistoMini.position.x = 9.5 if move_direction == 1 else -9.5
			$FirePoint.position.x = 13.8 if move_direction == 1 else -13.8
			if not $Moving.playing:
				$Moving.playing = true
		else:
			if $Moving.playing:
				$Moving.playing = false
			velocity.x = move_toward(move_direction, 0, speed)
			$AnimatedSprite2D.play("default")
		$CollisionShape2D.disabled = false
		$Crouched.disabled = true
	else:
		$PistoMini.position.x = 9.5 if $PistoMini.flip_h == false else -9.5
		$PistoMini.position.y = -2.0
		$CollisionShape2D.disabled = true
		$Crouched.disabled = false

func suggestion_box() -> void:      #Show The "E" button Prompt For Intraction
	can_intract = GlobalVariables.Intract_Prompt

	if can_intract == true:
		$Show_Prompt.visible = true
		$Show_Prompt.play("default")
	else:
		$Show_Prompt.visible = false
		$Show_Prompt.stop()

func _ready() -> void:
	print("Let's Do This Again :)")
	suggestion_box()

func _process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if Input.is_action_just_pressed("Jump") and can_jump:
			velocity.y -= jumpPower
	movement()
	move_and_slide()
	suggestion_box()

func OnHit(damange: int):
	PlayerHealth -= damange
	if PlayerHealth <= 0:
		get_tree().change_scene_to_file.call_deferred(GameOver)


func _on_timer_timeout() -> void:
	shootAble = true
