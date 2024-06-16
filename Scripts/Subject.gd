extends KinematicBody2D
class_name Subject

var observers = []

func _ready():
	pass # Replace with function body.

func add_observer(observer: Observer) -> void:
	observers.append(observer)

func remove_observer(observer: Observer) -> void:
	observers.erase(observer)

func notify_observers() -> void:
	for observer in observers:
		observer.update()
