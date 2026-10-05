extends Area2D

@export var BulletSpeed: float = 150.0
@export var DespawnBullet: float = 5.0
@export var BulletDamange: int = 10
@onready var GetPistolFacing: bool = get_parent().get_node("PistoMini").flip_h

func _ready() -> void:
	$AnimatedSprite2D.play("Shooting")

func _process(delta: float) -> void:
	if GetPistolFacing:
		position.x -=  BulletSpeed * delta
		$AnimatedSprite2D.flip_h = true
	else:
		position.x += BulletSpeed * delta
		$AnimatedSprite2D.flip_h = false
	get_tree().create_timer(DespawnBullet).timeout.connect(queue_free)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		body.OnHit(BulletDamange)
		queue_free()

# INFO:
# Use This If The Queue Free has Problems or You Want To add Particals
# $CollisionShape2D.set_deferred("disabled", true)
