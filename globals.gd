extends Node
signal damage_taken
var player_pos:Vector2
var boss_eye_pos:Vector3
var boss_body_pos:Vector3
var is_moving:bool
var damage_counter = 0
var is_infinite:bool = false
var started: bool = false
var main_menu: bool = false
var is_paused: bool = false
var pausable: bool = false
var insta_start: bool = false
var is_game_over: bool = false
var insta_menu:bool = false
var music_value:float = 1.0
signal health_change
var health = 6:
	get:
		return health
	set(value):
		if health > value:
			damage_counter+=1
			damage_taken.emit()
		if value <= 6: 
			health = value
		else:
			health = 6
		if is_infinite:
			health = 9999
		if health == 0:
			is_game_over = true
		health_change.emit()
