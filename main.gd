extends Node3D

const TILE = preload("uid://bq8etjaf4yerr")

const ROWS = 10
const COLS = 2

var tiles = []

var tile_move_speed = 1.0
var target_position = Vector3(0.0, 0.0, 4.0)


func _ready() -> void:
	for z in range(ROWS):
		for x in range(COLS):
			var tile = TILE.instantiate()
			add_child(tile)
			
			tile.position = Vector3(x * 4.0, 0.0, -(z * 4.0)) 
			tiles.append(tile)


func _physics_process(delta: float) -> void:
	tiles = tiles.filter(func(tile):
		if tile.position >= target_position:
			tile.queue_free()
			
			var new_tile = TILE.instantiate()
			add_child(new_tile)
			#new_tile.position = 
			
			return false
		
		tile.position.z += tile_move_speed * delta
		return true
	)
