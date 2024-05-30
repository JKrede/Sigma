extends Area2D

func _on_DeadArea_body_entered(body):
	body.set_global_position(Global.inicio)
	Global.contador_vida-=1
