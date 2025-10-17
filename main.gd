extends Node3D

const TILE = preload("uid://bq8etjaf4yerr")
const TILE_2 = preload("uid://c72eour81a4rk")
const TILE_3 = preload("uid://bla0epgbuladt")
const FENCE = preload("uid://0jan5lj41apr")
const BOX = preload("uid://bf0tmycgk4inu")

const ROWS = 10
const COLS = 2

var tiles = []
var obstacles = []

var tile_move_speed = 2.0
var target_position = Vector3(0.0, 0.0, 4.0)

var directions = [0, 90, 180, 270]

var tile_timer = 1.5 
var tile_just_spawned = false


func _ready() -> void:
	for z in range(ROWS):
		for x in range(COLS):
			var tile = _choose_random_tile().instantiate()
			add_child(tile)
			
			tile.position = Vector3(2.0 - (x * 4.0), 0.0, -(z * 4.0))
			tile.rotation = Vector3(0, deg_to_rad(_choose_random_dir()), 0)
			tiles.append(tile)
	
	for i in range(8):
		var rand = randf_range(0, 1)
		if rand >= 0.5:
			_generate_obstacle_fence(tiles[randi_range(0, tiles.size() - 1)])
		else:
			_generate_obstacle(tiles[randi_range(0, tiles.size() - 1)])


func _physics_process(delta: float) -> void:
	var tiles_to_remove = []
	var obstacles_to_remove = []
	
	for tile in tiles:
		if tile.position.z > target_position.z:
			tiles_to_remove.append(tile)
			continue
		
		tile.position.z += tile_move_speed * delta
	
	for obstacle in obstacles:
		if obstacle.position.z > target_position.z:
			obstacles_to_remove.append(obstacle)
			continue
		
		obstacle.position.z += tile_move_speed * delta
	
	for tile in tiles_to_remove:
		tile.queue_free()
		tiles.erase(tile)
		
		var new_tile = _choose_random_tile().instantiate()
		tiles.append(new_tile)
		new_tile.position = Vector3(tile.position.x, 0, -36)
		new_tile.rotation = Vector3(0, deg_to_rad(_choose_random_dir()), 0)
		
		add_child(new_tile)
	
	for obstacle in obstacles_to_remove:
		obstacle.queue_free()
		obstacles.erase(obstacle)
	
	if tile_just_spawned:
		tile_timer -= delta
		if tile_timer <= 0.0:
			tile_just_spawned = false
			tile_timer = 1.5
	else:
		var rand_num = randf_range(0, 1)
		if rand_num < 0.05 && obstacles.size() < 10:
			var rand_tile = tiles[randi_range(tiles.size() - 6, tiles.size() - 1)]
			var rand = randf_range(0, 1)
			if rand >= 0.5:
				_generate_obstacle_fence(rand_tile)
			else:
				_generate_obstacle(rand_tile)
			tile_just_spawned = true


func _choose_random_dir() -> float:
	return directions[randf_range(0, directions.size())]


func _choose_random_tile() -> PackedScene:
	var rand_num = randf_range(0, 1)
	
	if rand_num < 0.3:
		return TILE_3
	elif rand_num > 0.3 && rand_num < 0.75:
		return TILE_2
	
	return TILE


func _generate_obstacle_fence(tile) -> void:
	var children = tile.get_children()
	
	var spawn_points = []
	
	for child in children:
		if child.name == "Spawnpoints":
			var spawn_children = child.get_children()
			
			for spawn_child in spawn_children:
				spawn_points.append(spawn_child)
	
	var rand_num = randi_range(0, spawn_points.size() - 1)
	var spawn_point = spawn_points[rand_num]
	
	var fence = FENCE.instantiate()
	obstacles.append(fence)
	
	if spawn_point.name.begins_with("Rot"):
		fence.position = Vector3(spawn_point.global_position.x, 0.75, spawn_point.global_position.z)
		fence.rotation.y = spawn_point.global_rotation.y
	else:
		fence.position = Vector3(spawn_point.global_position.x, 0.75, spawn_point.global_position.z)
		fence.rotation.y = tile.global_rotation.y
	
	add_child(fence)
	
	spawn_points.clear()


func _generate_obstacle(tile) -> void:
	var children = tile.get_children()
	
	var obstacle_points = []
	
	for child in children:
		if child.name == "ObstaclePoints":
			var obstacle_children = child.get_children()
			
			for spawn_child in obstacle_children:
				obstacle_points.append(spawn_child)
	
	var rand_num = randi_range(0, obstacle_points.size() - 1)
	var obstacle_point = obstacle_points[rand_num]
	
	var box = BOX.instantiate()
	obstacles.append(box)
	
	box.position = Vector3(obstacle_point.global_position.x, 0.75, obstacle_point.global_position.z)
	box.rotation.y = randf_range(0, 360)
	add_child(box)
	
	obstacle_points.clear()
