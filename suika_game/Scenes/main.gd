extends Node2D

@export var ball_scene: PackedScene
@export var big_ball_scene: PackedScene
@export var very_big_ball_scene: PackedScene
@export var figue_scene: PackedScene

@onready var sprite_fraise = load("res://image/fraise.png")
@onready var sprite_baie = load("res://image/baie.png")
@onready var sprite_abricot = load("res://image/abricot.png")

@onready var fruit = $Fruit
@onready var prevision = $Prevision
@onready var next_fruit = $Next_Fruit

const spawn_fruit = 224
const baie_scale = Vector2(2.269, 2.251)
const abricot_scale = Vector2(2.011, 2.138)
const fraise_scale = Vector2(1.258, 1.065)

var fruit_actuelle = 1
var nbr = 1
var random

# Called when the node enters the scene tree for the first time.
func _ready():
	var global = get_node("/root/Global")
	global.connect("collision", big_ball)
	global.connect("collision_big", very_big_ball)
	global.connect("collision_very_big", figue)
	random_sprite()
	fruit.scale = baie_scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	show_ball()

#lorsque le joueur clique
func _input(event):
	if Input.is_action_just_pressed("clique_gauche") && $Action.is_stopped():
		var ball
		#va créer une instance du fruit actuelle
		if (fruit_actuelle == 1): 
			ball = ball_scene.instantiate()
			ball.position.y = spawn_fruit
		elif (fruit_actuelle == 2): 
			ball = big_ball_scene.instantiate()
			ball.position.y = spawn_fruit
		elif (fruit_actuelle == 3): 
			ball = very_big_ball_scene.instantiate() 
			ball.position.y = spawn_fruit
		
		ball.position.x = limit_souris()
		
		#fruit actuelle devient fruit random
		fruit_actuelle = random
		
		#va mettre le sprite à afficher lorsqu'on choisit où poser
		if (random == 1):
			fruit.set_texture(sprite_baie)
			fruit.scale = baie_scale
			fruit.position.y = spawn_fruit
		elif (random == 2):
			fruit.set_texture(sprite_abricot)
			fruit.scale = abricot_scale
			fruit.position.y = spawn_fruit
		elif (random == 3):
			fruit.set_texture(sprite_fraise)
			fruit.scale = fraise_scale
			fruit.position.y = spawn_fruit
		
		add_child(ball)
		$Action.start()
		$Show_sprite.start()
		random_sprite()

#instancie very big ball
func big_ball():
	if(nbr == 1):
		var big_ball = big_ball_scene.instantiate()
		big_ball.position = Global.possition_ball
		add_child(big_ball)
		nbr = 0
	elif(nbr == 0):
		nbr = 1

#instancie very big ball
func very_big_ball():
	if(nbr == 1):
		var very_big_ball = very_big_ball_scene.instantiate()
		very_big_ball.position = Global.possition_ball
		add_child(very_big_ball)
		nbr = 0
	elif(nbr == 0):
		nbr = 1

#instancie figue
func figue():
	if(nbr == 1):
		var figue = figue_scene.instantiate()
		figue.position = Global.possition_ball
		add_child(figue)
		nbr = 0
	elif(nbr == 0):
		nbr = 1

#montre la balle et la trajectoire
func show_ball():
	if($Show_sprite.is_stopped()):
		fruit.show()
		fruit.position.x = limit_souris()
		
		prevision.show()
		prevision.position.x = limit_souris() -3
		prevision.position.y = spawn_fruit
	else: 
		fruit.hide()
		prevision.hide()

#limit côté pour la balle
func limit_souris():
	if(get_viewport().get_mouse_position().x < 30 + fruit_actuelle*10): return 30 + fruit_actuelle*10
	elif(get_viewport().get_mouse_position().x > 574 - fruit_actuelle*10): return 574 - fruit_actuelle*10
	else: return get_viewport().get_mouse_position().x

#timer finit
func _on_show_sprite_timeout():
	$Show_sprite.stop()

#timer finit
func _on_action_timeout():
	$Action.stop()

#random sprite
func random_sprite():
	random = randi_range(1, 3)
	
	if (random == 1):
		next_fruit.set_texture(sprite_baie)
		next_fruit.scale = baie_scale
	elif (random == 2):
		next_fruit.set_texture(sprite_abricot)
		next_fruit.scale = abricot_scale
	elif (random == 3):
		next_fruit.set_texture(sprite_fraise)
		next_fruit.scale = fraise_scale
	
