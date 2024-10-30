extends Node3D
var multiplier: float = 1
var speed: float = 1
var is_spinning: bool = false
func change_color(color: Color):
	$pillar.material_override.set_emission_energy_multiplier(multiplier)
	$pillar.material_override.set_emission(color)
	$pipes.material_override.set_emission_energy_multiplier(multiplier)
	$pipes.material_override.set_emission(color)
	var tween = create_tween()
	tween.tween_method(change_energy_multiplier, multiplier, 0.0, 2.0)
func change_energy_multiplier(val):
	$pillar.material_override.set_emission_energy_multiplier(val)
	$pipes.material_override.set_emission_energy_multiplier(val)
func reset_emission():
	$pillar.material_override.set_emission_energy_multiplier(0)
	$pipes.material_override.set_emission_energy_multiplier(0)
func _process(delta: float) -> void:
	if is_spinning:
		rotation.y -= speed*delta
func start_spin():
	is_spinning = true
func change_speed():
	var tween = create_tween()
	tween.tween_method(add_val, 1.0, 2.0, 1)
func change_speed_again():
	var tween = create_tween()
	tween.tween_method(add_val, 2.0, 0.0, 20)
func add_val(val:float):
	speed = val
