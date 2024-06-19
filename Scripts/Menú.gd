extends Control

func _ready():
	$VBoxContainer/ComenzarButton.grab_focus()

func _on_ComenzarButton_pressed():
	get_tree().change_scene("res://Scenes/Mundo1.tscn")


func _on_ContinuarButton_pressed():
	pass

func _on_OpcionesButton_pressed():
	pass # Replace with function body.


func _on_SalirButton_pressed():
	get_tree().quit()
	


