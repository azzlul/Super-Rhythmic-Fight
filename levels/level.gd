extends Node2D
@export var animation_start_time:float = 0
@export var time_multiplier: float = 1

#var color_vector = [Color.DARK_RED, Color8(148, 89, 0, 0), Color8(158, 153, 0, 0), Color.DARK_GREEN, Color.DARK_BLUE, Color.INDIGO, Color8(87, 0, 176, 0)]
var color_vector = [Color8(200, 0, 0), Color8(209, 135, 0), Color8(199, 199, 0), Color8(0, 201, 0), Color8(0, 0, 204), Color8(75, 0, 130), Color8(100, 0, 201)]
var current_color = 0
var game_over_screen_appeared: bool = false
var audio_time:float = 0
func ready():
	$SubViewportContainer2/SubViewport2/Camera3D.set_enviroment($SubViewportContainer/SubViewport/Camera3D.get_enviroment())
	change_color()
func _process(_delta):
	$AudioStreamPlayer.volume_db = linear_to_db($"HSlider".value)
	if Globals.insta_menu:
		Globals.health_change.connect(_on_health_change)
		$health_bar.visible = false
		$Bullets.visible = true
		$"main menu/CheckButton".button_pressed = Globals.is_infinite
		$HSlider.value = Globals.music_value
		Globals.damage_counter = 0
		Globals.health = 6
		Globals.insta_menu = false
		$WarningText.visible = false
		$Player.visible = true
		Globals.main_menu = true
		$"main menu".visible = true
		$HSlider.visible = true
	if Globals.insta_start:
		Globals.pausable = true
		Globals.health_change.connect(_on_health_change)
		$health_bar.visible = true
		if not Globals.is_infinite:
			$health_bar/hp.text = "HP:6/6"
		else:
			$health_bar/hp.text = "HP:inf"
		$Bullets.visible = true
		$"main menu/CheckButton".button_pressed = Globals.is_infinite
		$HSlider.value = Globals.music_value
		Globals.damage_counter = 0
		Globals.health = 6
		get_tree().paused = false
		Globals.insta_start = false
		$WarningText.visible = false
		$Player.visible = true
		$AnimationPlayer.play("Level")
		$AnimationPlayer.seek(animation_start_time)
		$AudioStreamPlayer.play(animation_start_time)
		Engine.set_time_scale(time_multiplier)
		$AudioStreamPlayer.pitch_scale = time_multiplier
	elif Input.is_action_just_pressed("begin") and not Globals.main_menu and not Globals.started:
		Globals.health_change.connect(_on_health_change)
		$SubViewportContainer/SubViewport/SpotLight3D.light_energy = 0
		$SubViewportContainer/SubViewport/door.visible = true
		$SubViewportContainer/SubViewport/boss_parts2.visible = true
		$SubViewportContainer2/SubViewport2/SpotLight3D.light_energy = 0
		$SubViewportContainer/SubViewport/room.visible = true
		$SubViewportContainer/SubViewport/hallway.visible = true
		$SubViewportContainer/SubViewport/boss.visible = true
		$SubViewportContainer/SubViewport/boss_parts2.start_anim()
		$WarningText.visible = false
		$Player.visible = true
		Globals.main_menu = true
		$"main menu".visible = true
		$HSlider.visible = true
	elif (Input.is_action_just_pressed("begin") and not Globals.started):
		$health_bar.visible = true
		if not Globals.is_infinite:
			$health_bar/hp.text = "HP:6/6"
		else:
			$health_bar/hp.text = "HP:inf"
		Globals.damage_counter = 0
		Globals.health = 6
		Globals.pausable = true
		$Bullets.visible = true
		clear_bullets()
		$AnimationPlayer.play("Level")
		$AnimationPlayer.seek(animation_start_time)
		$AudioStreamPlayer.play(animation_start_time)
		Engine.set_time_scale(time_multiplier)
		$AudioStreamPlayer.pitch_scale = time_multiplier
		$"main menu".visible = false
		Globals.started = true
		$HSlider.visible = false
	if Input.is_action_just_pressed("pause") and not Globals.is_game_over and Globals.pausable:
		if Globals.is_paused == false:
			audio_time = $AnimationPlayer.get_current_animation_position()
			$AudioStreamPlayer.stop()
			Globals.is_paused = true
			$"pause menu".visible = true
			$HSlider.visible = true
			get_tree().paused = true
		else:
			Globals.is_paused = false
			$"pause menu".visible = false
			$HSlider.visible = false
			get_tree().paused = false
			$AudioStreamPlayer.play(audio_time)
	if Globals.is_game_over and not game_over_screen_appeared:
		game_over_screen_appeared = true 
		Globals.is_paused = true
		$"Game Over Screen".visible = true
		get_tree().paused = true
func quit():
	print("Hits took:")
	print(Globals.damage_counter)
	get_tree().quit()
func resync_audio(val:float):
	$AudioStreamPlayer.play(val)
func change_color():
	$SubViewportContainer/SubViewport/door.change_color(color_vector[current_color])
	$SubViewportContainer/SubViewport/hallway.change_color(color_vector[current_color])
	$SubViewportContainer/SubViewport/boss.change_color(color_vector[current_color])
	$SubViewportContainer/SubViewport/room.change_color(color_vector[current_color])
	if current_color < 6:
		current_color += 1
	else:
		current_color = 0
func clear_bullets():
	for bullet in get_tree().get_nodes_in_group("Bullet"):
		if "is_delay" in bullet:
			if bullet.is_delay == true:
				continue
		bullet.queue_free()

func reset_colors():
	$SubViewportContainer/SubViewport/door.reset_emission()
	$SubViewportContainer/SubViewport/hallway.reset_emission()
	$SubViewportContainer/SubViewport/boss.reset_emission()
	$SubViewportContainer/SubViewport/room.reset_emission()
func _on_retry_button_pressed() -> void:
	Globals.insta_start = true
	Globals.is_paused = false
	Globals.is_game_over = false
	game_over_screen_appeared = false
	reset_colors()
	$"Game Over Screen".visible = false
	get_tree().reload_current_scene()
	

func _on_main_menu_button_pressed() -> void:
	Globals.insta_menu = true
	Globals.pausable =  false
	Globals.started = false
	Globals.is_paused = false
	get_tree().paused = false
	Globals.is_game_over = false
	game_over_screen_appeared = false
	reset_colors()
	$"Game Over Screen".visible = false
	get_tree().reload_current_scene()
func set_pausable():
	Globals.pausable = false
	$"ending screen/RichTextLabel3".text = str("YOU GOT HIT " , Globals.damage_counter , " TIMES")


func _on_check_button_toggled(toggled_on: bool) -> void:
	Globals.is_infinite = toggled_on


func _on_button_pressed() -> void:
	get_tree().quit()


func _on_h_slider_value_changed(value: float) -> void:
	Globals.music_value = $HSlider.value

func _on_health_change():
	if not Globals.is_infinite:
		$health_bar/hp.text = str("HP:" , Globals.health , "/6")
