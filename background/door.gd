extends Node3D

var multiplier: float = 1
func change_color(color: Color):
	$Cube/Plane_001.material_override.set_emission_energy_multiplier(multiplier)
	$Cube_001/Plane.material_override.set_emission_energy_multiplier(multiplier)
	$Cube/Plane_001.material_override.set_emission(color)
	$Cube_001/Plane.material_override.set_emission(color)
	var tween = create_tween()
	tween.tween_method(change_energy_multiplier, multiplier, 0.0, 2)
func change_energy_multiplier(val):
	$Cube/Plane_001.material_override.set_emission_energy_multiplier(val)
	$Cube_001/Plane.material_override.set_emission_energy_multiplier(val)
func open_door():
	var tween = create_tween()
	tween.tween_method(move_door, 0.0, 220.0, 12)
func reset_emission():
	$Cube/Plane_001.material_override.set_emission_energy_multiplier(0)
	$Cube_001/Plane.material_override.set_emission_energy_multiplier(0)
func move_door(val):
	$Cube.position.z = val
	$Cube_001.position.z = -val
