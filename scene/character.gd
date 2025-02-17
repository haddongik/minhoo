extends CharacterBody2D

@onready var ghost = $Ghost

func test_call(next:int):
	ghost.set_dir(next)
	ghost.is_emitting = true
