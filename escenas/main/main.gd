extends Node2D

var game_type:int 	= 0;
var times:Array[int]=[50,35,30,45,40,55,50,60,25,35,30,45,40,55]; 
var seconds:int 	= 0;
var rng 			= RandomNumberGenerator.new()
var flag 			= 0;
var running			= false; 
var paused			= false; 


func _ready() -> void:
	$Timer.connect("timeout",Callable(self,"_count"));
	$Timer.set_wait_time(1);
	$Timer.start();
	$Timer.paused = true;
	pass
	
func _input(event: InputEvent) -> void:
	"""if event is InputEventMouseButton:
		if event.is_pressed():
			if(running):
				if(paused):
					paused = false;
					_resume();
				else:
					paused = true;
					_pause();
				
				pass"""
	pass
	
func _select_mode() -> void: 

	pass
	
func _count() -> void:
	seconds -= 1;
	var lbl:String = str(seconds);
	if(seconds<10):
		lbl = "0"+lbl;
	$minutos.text = lbl;
	if(flag==0):
		flag = 1;
		$flag.color =  Color(1, 0, 0);
	else:
		flag = 0;
		$flag.color =  Color(1, 1, 1);
	if(seconds==0):
		$Timer.paused 	= true;
		pass
	pass
	
func _start() -> void:
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
	flag = 0;
	$flag.color =  Color(1, 1, 1);
	print("SE ACABO")
	running = false;
	pass


#modos
func _on_countdown_pressed() -> void:
	seconds = 60;
	game_type = 0;
	_start();
	pass # Replace with function body.


func _on_random_pressed() -> void:
	var nbr = rng.randi_range(0,(times.size()-1));
	seconds = times[nbr];
	game_type = 1;
	_start();
	pass # Replace with function body.


func _on_restart_pressed() -> void:
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
	pass # Replace with function body.


func _on_pause_pressed() -> void:
	if(paused):
		paused = false;
		_resume();
		
	else:
		paused = true;
		_pause();
		
	pass # Replace with function body.
