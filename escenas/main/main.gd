extends Node2D

var game_type:int 	= 0;
var times:Array[int]=[50,35,30,45,40,55,50,60,25,35,30,45,40,55]; 
var seconds:int 	= 0;
var rng 			= RandomNumberGenerator.new()
var flag 			= 0;
var running			= false; 
var paused			= false; 
var backsnd 		= true;

var pattern_dir 	= 0;
var misil_dir 		= 0;
var bomb_back		= 0;


var pause_sfx 		= preload("res://assets/sounds/pausa.wav");
var action_sfx 		= preload("res://assets/sounds/action.wav");
var tic_sfx 		= preload("res://assets/sounds/timer_large.wav");
var boom_sfx 		= preload("res://assets/sounds/explosion_short.wav");

var audioOn 		= preload("res://assets/icons/audioOn.png");
var audioOff		= preload("res://assets/icons/audioOff.png");

var pattern_tween:Tween;
var misil_tween:Tween;
var bombi_tween:Tween;


func _ready() -> void:
	$Timer.connect("timeout",Callable(self,"_count"));
	$Timer.set_wait_time(1);
	$Timer.start();
	$Timer.paused = true;
	
	bombi_tween = create_tween();
	bombi_tween.set_loops(-1)
	bombi_tween.tween_property($bomba,"scale",Vector2(1,1),1).from(Vector2(1.2,1.2))
	
	pattern_tween 	= create_tween()
	misil_tween 	= create_tween()
	#change_back_bomb();
	pattern_animate()
	misil_animate()
	pass
	
func change_back_bomb()-> void:
	var nbr = rng.randi_range(0,5);
	print(nbr);
	if(nbr == 1 or nbr == 3 or nbr == 5):
		$bomba.visible = true;
		$misil.visible = false;
	else:
		$bomba.visible = false;
		$misil.visible = true;
	pass

func pattern_animate()-> void:
	if pattern_tween:
		pattern_tween.kill()
	pattern_tween = create_tween()
	if(pattern_dir==0):
		pattern_dir = 1;
		var newdir:Vector2 = Vector2($patron.position.x-50,$patron.position.y-60)
		pattern_tween.tween_property($patron,"position",newdir,5)
	else:
		pattern_dir = 0;
		var newdir:Vector2 = Vector2($patron.position.x+50,$patron.position.y+60)
		pattern_tween.tween_property($patron,"position",newdir,5)
	pattern_tween.tween_callback(pattern_animate)
	pass
	
func misil_animate()-> void:
	if misil_tween:
		misil_tween.kill()
	misil_tween = create_tween()
	if(misil_dir==0):
		misil_dir = 1;
		misil_tween.tween_property($misil,"position:x",$misil.position.x+100,5)
	else:
		misil_dir = 0;
		misil_tween.tween_property($misil,"position:x",$misil.position.x-100,1)
	misil_tween.tween_callback(misil_animate)
	pass

func _count() -> void:
	if !$sfx.is_playing():
		$sfx.stream = tic_sfx;
		$sfx.play()
	seconds -= 1;
	var lbl:String = str(seconds);
	if(seconds<10):
		lbl = "0"+lbl;
	$minutos.text = lbl;
	if(flag==0):
		flag = 1;
		$flag.color =  Color(1, 0.2, 0.2);
	else:
		flag = 0;
		$flag.color =  Color(1, 1, 1);
	if(game_type==0):
		var tween = create_tween();
		tween.tween_property($minutos,"scale",Vector2(1.0,1.0),0.2).from(Vector2(1.2,1.2))
		pass	
	if(seconds==0):
		$Timer.paused 	= true;
		_timeup();
		pass
	pass
	
func _start() -> void:
	
	change_back_bomb();
	$logo.visible 		= false;
	$logo_grande.visible= false;
	$logo_peque.visible	= true;
	paused 				= false;
	running				= true;
	$minutos.text       = str(seconds); 
	$random.visible 	= false;
	$countdown.visible 	= false;
	$pause.visible		= true;
	if(game_type==0):
		$minutos.visible 	= true;
	$Timer.paused 		= false;
	pass	
	
func _pause() -> void:
	$Timer.paused 		= true;
	$restart.visible 	= true;
	pass
	
func _resume() -> void:
	$Timer.paused 		= false;
	$restart.visible 	= false;
	pass
	
func _timeup() -> void:
	if !$actions.is_playing():
		$actions.stream = boom_sfx;
		$actions.play()
	flag 				= 0;
	$flag.color 		=  Color(1, 1, 1);
	running 			= false;
	$explosion.visible 	= true;
	$explosion.play()
	
	pass


#modos
func _on_countdown_pressed() -> void:
	if !$actions.is_playing():
		$actions.stream = action_sfx;
		$actions.play()
	seconds = 60;
	game_type = 0;
	_start();
	pass # Replace with function body.


func _on_random_pressed() -> void:
	if !$actions.is_playing():
		$actions.stream = action_sfx;
		$actions.play()
	var nbr = rng.randi_range(0,(times.size()-1));
	seconds = times[nbr];
	game_type = 1;
	_start();
	pass # Replace with function body.


func _on_restart_pressed() -> void:
	$logo.visible 		= true;
	if !$actions.is_playing():
		$actions.stream = action_sfx;
		$actions.play()
	paused 				= false;
	running				= false;
	flag 				= 0;
	$Timer.paused 		= true;
	$restart.visible 	= false;
	$random.visible 	= true;
	$countdown.visible 	= true;
	$minutos.visible 	= false;
	$pause.visible		= false; 	
	$flag.color =  Color(1, 1, 1);	
	$logo_grande.visible= true;
	$logo_peque.visible	= false;
	$misil.visible 		= false;
	$bomba.visible 		= false;
	pass # Replace with function body.


func _on_pause_pressed() -> void:
	if !$actions.is_playing():
		$actions.stream = pause_sfx;
		$actions.play()
	if(paused):
		paused = false;
		_resume();
		
	else:
		paused = true;
		_pause();
		
	pass # Replace with function body.


func _on_audio_pressed() -> void:
	if !$actions.is_playing():
		$actions.stream = action_sfx;
		$actions.play()
	if(backsnd):
		backsnd = false;
		$audio.icon =audioOff;
		$back.stop()
	else:
		$audio.icon = audioOn;
		backsnd = true;
		$back.play()
	pass # Replace with function body.


func _on_explosion_animation_finished() -> void:
	_on_restart_pressed();
	pass # Replace with function body.
