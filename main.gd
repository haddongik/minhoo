extends Node2D

@export var height:int
@export var pack_player:PackedScene
@export var pack_tile:PackedScene

class floor_info:
	var pos:int
	var floor:int
	
	func _init(_pos:int,_floor:int):
		pos = _pos
		floor = _floor	

var player:Node2D
var score:int
var current_floor:floor_info
var floor_queue:Array[floor_info]
var floor_tiles:Array[Node2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_make_player()
	_make_floors(height)
	_make_tiles(height)
	_update_tiles()
	
	score = 0
	_update_score()
	
	current_floor = floor_queue.pop_front()
	_update_player()
	
	$CanvasLayer/GameOver.visible = false
	$CanvasLayer/Restart.visible = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_left"):
		_move_step(-1)
	elif Input.is_action_just_pressed("ui_right"):
		_move_step(1)

func _is_out_of_screen(node: Node2D) -> bool:
	var viewport_size = get_viewport_rect().size
	var pos = node.global_position
	return pos.x < 0 or pos.x > viewport_size.x or pos.y < 0 or pos.y > viewport_size.y

func _make_player():
	player = pack_player.instantiate()
	add_child(player)
	
func _make_floor():
	var new_floor = null
	if floor_queue.size() == 0:
		new_floor = floor_info.new(0,1)
	else:
		var prev_floor = floor_queue.back()
		var new_dir = 1 if randi() % 2 == 0 else -1
		var new_pos = prev_floor.pos + new_dir
		new_floor = floor_info.new(new_pos,prev_floor.floor + 1)
	
	floor_queue.append(new_floor)
	
func _make_floors(count:int):
	for i in count:
		_make_floor()
	
func _move_step(next:int):
	var next_floor = floor_queue.pop_front()

	print("your input", next)
	print("expect input", next_floor.pos - current_floor.pos)
	
	if next_floor.pos - current_floor.pos == next:
	#if true:
		print("correct")
		current_floor = next_floor
		score += 1
		
		_make_floor()
		_update_tiles()
		_update_player()
		_update_score()
	else:
		_game_over()

func _make_tiles(count:int):
	for i in count:
		var tile:Node2D = pack_tile.instantiate()
		tile.global_position = Vector2(tile.global_position.x, 750 - (i * 80))
		add_child(tile)
		floor_tiles.append(tile)
		
func _update_tiles():
	for index in floor_queue.size():
		var screen_center_x = get_viewport_rect().size.x / 2
		var new_x = screen_center_x + (floor_queue[index].pos * 200)
		floor_tiles[index].global_position = Vector2(new_x,floor_tiles[index].global_position.y)

func _update_player():
	player.global_position = floor_tiles[0].global_position
	player.global_position += Vector2(100,-50)
	
func _update_score():
	$CanvasLayer/Score.text = "점수: %d" % score
	
func _game_over():
	print("game over")
	$CanvasLayer/GameOver.visible = true
	$CanvasLayer/Restart.visible = true

func clear_all():
	current_floor = null
	player.queue_free()
	floor_queue.clear()
	for tile in floor_tiles:
		if tile != null and tile.is_inside_tree():
			remove_child(tile)
			tile.queue_free()
	floor_tiles.clear()  # 배열 비우기
	
func _on_restart_pressed() -> void:
	clear_all()
	_ready()
