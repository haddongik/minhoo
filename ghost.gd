extends Sprite2D

var fading: PackedScene = preload("res://scene/fading.tscn")
var dir:int

@export var spawn_rate := 0.1: set = set_spawn_rate
@export var is_emitting := false: set = set_is_emitting
@onready var _timer := $TrailTimer

func set_dir(_dir:int):
	dir = _dir
	
func set_is_emitting(value: bool) -> void:
	is_emitting = value
	if not is_inside_tree():
		await self.ready

	if is_emitting:
		_spawn_ghost(dir * 20 * 2, 40)
		_spawn_ghost(dir * 20 * 4, 30)
		_spawn_ghost(dir * 20 * 6, 20)
		_spawn_ghost(dir * 20 * 8 ,10)

		_timer.start()
	else:
		_timer.stop()


func set_spawn_rate(value: float) -> void:
	spawn_rate = value
	if not _timer:
		await self.ready

	_timer.wait_time = 1.0 / spawn_rate

func _spawn_ghost(offset_x:int, offset_y:int) -> void:
	var ghost := fading.instantiate()

	ghost.offset = offset
	ghost.texture = texture
	ghost.flip_h = flip_h
	ghost.flip_v = flip_v
	add_child(ghost)
	ghost.set_as_top_level(true)
	ghost.global_position = Vector2(global_position.x+offset_x, global_position.y+offset_y)


func _on_trail_timer_timeout() -> void:
	pass
	#_spawn_ghost()
