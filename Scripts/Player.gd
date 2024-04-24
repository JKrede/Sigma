extends KinematicBody2D

const moveSpeed=10
const maxSpeed=100
const jumpHeight=-300

const up=Vector2(0,-1)
const gravity=10;

onready var sprite=$Sprite
onready var animationPlayer=$AnimationPlayer

var motion=Vector2()
 
func _physics_process(delta):
	motion.y+= gravity
	var friction=false
	
	if Input.is_action_pressed("ui_right"):
		sprite.flip_h=false
		motion.x=min(motion.x+moveSpeed,maxSpeed)
		
	elif Input.is_action_pressed("ui_left"):
		sprite.flip_h=true
		motion.x=max(motion.x-moveSpeed,-maxSpeed)
		
	else:
		friction=true
		
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			motion.y=jumpHeight
			animationPlayer.play("Jump")
		if friction==true:
			motion.x=lerp(motion.x,0,1)
		if motion.x!=0:
			animationPlayer.play("Walk")
		
		if motion.x==0:
			animationPlayer.play("Idle")
	else:
		if friction==true:
			motion.x=lerp(motion.x,0,1)
		if motion.y<0:
			animationPlayer.play("Fall")
			
	if Input.is_action_pressed("ui_at1"):
		animationPlayer.play("Punch")
		##Aca iria el efecto de esto
		
	if Input.is_action_pressed("ui_at2"):
		animationPlayer.play("Kick")
		##Aca iria el efecto de esto
	motion=move_and_slide(motion,up)
				
