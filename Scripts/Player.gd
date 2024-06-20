extends Subject
class_name Player

const moveSpeed = 100
const maxSpeed = 130
const jumpHeight = -350
const gravity = 10
const up = Vector2(0, -1)
const inicio = Vector2(1, 1)

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer

var enemyIsNear = false # Indica si algún enemigo está en rango de ataque
var enemy = null # Indica el cuerpo del enemigo que está en rango de ataque
var isAlive = true # Indica si el jugador está vivo
var isAttacking = false # Indica si el pj está atacando
var isTakingDamage = false # Indica si el pj está siendo atacado

var motion = Vector2()

func _physics_process(delta):
	
	motion.y += gravity
	var friction = false

	if not isAttacking and not isTakingDamage:
		if Input.is_action_pressed("ui_right"):
			sprite.flip_h = false
			motion.x = min(motion.x + moveSpeed, maxSpeed)
		elif Input.is_action_pressed("ui_left"):
			sprite.flip_h = true
			motion.x = max(motion.x - moveSpeed, -maxSpeed)
		else:
			friction = true

	if is_on_floor():
		if not isAttacking and not isTakingDamage:
			if Input.is_action_pressed("ui_up"):
				motion.y = jumpHeight
			if friction == true:
				motion.x = lerp(motion.x, 0,1)
			if motion.x != 0:
				animationPlayer.play("Walk")
			if motion.x == 0:
				animationPlayer.play("Idle")
	else:
		if motion.y < 0 and not isAttacking and not isTakingDamage:
			animationPlayer.play("Jump")
		elif motion.y > 0 and not isAttacking and not isTakingDamage:
			animationPlayer.play("Fall")

	attack()
	live_check()
	motion = move_and_slide(motion, up)

func attack():
	if not isAttacking and not isTakingDamage and motion.x==0:
		if Input.is_action_pressed("ui_at1"):
			isAttacking = true
			$PunchFX.stream.loop=false
			$PunchFX.play()
			animationPlayer.play("Punch")
		elif Input.is_action_pressed("ui_at2"):
			isAttacking = true
			$KickFX.stream.loop=false
			$KickFX.play()
			animationPlayer.play("Kick")

func take_damage(damageTaken):
	if isTakingDamage==false:
		animationPlayer.play("TakingDamage")
		Global.actualLife -= damageTaken
		if Global.actualLife < 0:
			Global.actualLife = 0

func live_check():
	if Global.actualLife==0:
		isAlive=false
	if not isAlive:
		Global.contador_vida-=1
		if Global.contador_vida==0:
			print("Game over")
		Global.actualLife=Global.maxLife
		set_global_position(inicio)
		print(Global.contador_vida)
		isAlive=true
	if Global.actualLife<50:
		notify_observers()
	if Global.actualLife>=50:
		notify_observers()

func _on_AttackArea_body_entered(body):
	enemy = body
	enemyIsNear = true

func _on_AttackArea_body_exited(body):
	enemy = null
	enemyIsNear = false

func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "Punch" or anim_name == "Kick":
		isAttacking = true
	elif anim_name == "TakingDamage":
		isTakingDamage = true

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Punch":
		if enemyIsNear:
			if enemy.actualLife-50<=0:
				remove_observer(enemy)
			enemy.take_damage(50)
		isAttacking=false
	if anim_name == "Kick":
		if enemyIsNear:
			if enemy.actualLife-200<=0:
				remove_observer(enemy)
			enemy.take_damage(200)
		isAttacking=false
	if anim_name == "TakingDamage":
		isTakingDamage=false

func _on_DeadArea_body_entered(body):
	if not body is Enemy:
		take_damage(1000)
		
func _ready():
	var Mundo = get_parent()
	if Mundo:
		for child in Mundo.get_children():
			if child is Enemy:
				add_observer(child)

func save_game():
	return {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"x_pos" : position.x,
		"y_pos" : position.y,
		"stats" :{
			"contador_oro" : Global.contador_oro,
			"contador_plata" : Global.contador_plata,
			"contador_vida" : Global.contador_vida,
			"actualLife" : Global.actualLife,
			"contador_kills" : Global.contador_kills,
		}
	}

func load_game(stats):
	position = Vector2(stats.x_pos, stats.y_pos)
	Global.contador_oro = stats.stats.contador_oro
	Global.contador_plata = stats.stats.contador_plata
	Global.contador_vida = stats.stats.contador_vida
	Global.actualLife = stats.stats.actualLife
	Global.contador_kills = stats.stats.contador_kills
	


func _on_Level_up_area_body_entered(body):
	if not body is Enemy:
		get_tree().change_scene("res://Scenes/Mundo2.tscn")
