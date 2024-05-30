extends Area2D

var collected = false


func save_game():
	return {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"x_pos" : position.x,
		"y_pos" : position.y,
		"stats" :{
			"collected" : collected
		}
	}

func load_game(stats):
	position = Vector2(stats.x_pos, stats.y_pos)
	if stats.stats.collected:
		queue_free()
	else:
		collected=stats.stats.collected


func _on_Ramen_body_entered(body):
	if body is Player:
		collected = true
		Global.actualLife += Global.puntos_ramen
		if Global.actualLife>Global.maxLife:
			Global.actualLife=Global.maxLife
		queue_free()
	else:
		# Si el cuerpo que entra no es el del jugador, no hacemos nada
		pass
