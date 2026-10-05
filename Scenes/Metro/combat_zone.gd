extends Area2D

#Combat Zone (Area 2D) Variable
@export var ZoneDespawnTimer: float = 4.0
var once: bool = true

#Portals Variable
@onready var portal1: Sprite2D = $Marker2D/Portal1
@onready var portal2: Sprite2D = $Marker2D2/Portal2
@onready var portal3: Sprite2D = $Marker2D3/Portal3
@onready var portal4: Sprite2D = $Marker2D4/Portal4

#Initializing Goons Variable
@export var Goons: PackedScene = preload("res://Other-Characters/goons/goons.tscn") 
@export var SpawnPoint: Array[Marker2D]
@export var SpawnDelay: float = 2.0
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
	await get_tree().create_timer(SpawnDelay).timeout
	for i in SpawnPoint:
		goons = Goons.instantiate()
		get_node("../").add_child(goons)
		goons.position = i.position

func portalMangement() -> void:
	portal1.show()
	portal2.show()
	portal3.show()
	portal4.show()
