extends Area2D

var observers=[]

func _on_PergaminoVerde2D_body_entered(body):
	if body is Player:
		add_observer(body)
		notify_observer()
		queue_free()
		
func add_observer(o):
	observers.append(o)

func erase_observer(o):
	observers.erase(o)

func notify_observer():
	for obs in observers:
		obs.pergamino_verde_collected()


func save_game():
	return {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"x_pos" : position.x,
		"y_pos" : position.y,
		"stats" :{
			"green" : Global.green
		}
	}

func load_game(stats):
	position = Vector2(stats.x_pos, stats.y_pos)
	if stats.stats.green:
		queue_free()
	else:
		Global.green=stats.stats.green
