extends Node3D
var multiplier: float = 1
func change_color(color: Color):
	$Cylinder/Cylinder_001.material_override.set_emission_energy_multiplier(multiplier)
	$Cylinder/Cylinder_001.material_override.set_emission(color)
	$Cylinder/Cylinder_002.material_override.set_emission_energy_multiplier(multiplier)
	$Cylinder/Cylinder_002.material_override.set_emission(color)
	var tween = create_tween()
	tween.tween_method(change_energy_multiplier, multiplier, 0.0, 1.5)
func change_energy_multiplier(val):
	$Cylinder/Cylinder_001.material_override.set_emission_energy_multiplier(val)
	$Cylinder/Cylinder_002.material_override.set_emission_energy_multiplier(val)
func start_move():
	$AnimationPlayer.play("move")
	$AnimationPlayer2.play("speen")
func reset_emission():
	$Cylinder/Cylinder_001.material_override.set_emission_energy_multiplier(0)
	$Cylinder/Cylinder_002.material_override.set_emission_energy_multiplier(0)
func stop_move():
	$AnimationPlayer.pause()
	$AnimationPlayer2.pause()
