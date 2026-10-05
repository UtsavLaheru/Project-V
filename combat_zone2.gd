extends Area2D

#Combat Zone (Area 2D) Variable
@export var ZoneDespawnTimer: float = 4.0
var once: bool = true

#Portals Variable
#var portal1: Sprite2D = $Marker2D/Portal1   #Make This As Array For Easy Addition

#Initializing Goons Variable
@export var Goons: PackedScene = preload("res://Other-Characters/goons/goons.tscn") 
@export var SpawnPoint: Array[Marker2D]
# var SpawnDelay: float = 2.0
var goons

# NOTE:Spawn Delay Must Not Be Closer or Greater Then ZoneDespawnTimer
func _on_body_entered(body: Node2D) -> void:
		if body.name == "Player" and once:
			print("Player Has Entered The Combat Zone")
			portalMangement()
			spawner()
			get_tree().create_timer(ZoneDespawnTimer).timeout.connect(queue_free)
			get_node("../Player/PistoMini").visible = true
			once = false

func spawner() -> void:
	# await get_tree().create_timer(SpawnDelay).timeout
	for i in SpawnPoint:
		goons = Goons.instantiate()
		owner.call_deferred("add_child", goons)
		goons.position = i.global_position

func portalMangement() -> void:
	for i in SpawnPoint:
		i.get_child(0).show()
