extends Node2D

var args:Array=[];
var work_dir;
var user_data;
var work_dir_arg;

func _ready():
	args = OS.get_cmdline_args();
	work_dir = OS.get_executable_path();
	user_data = OS.get_user_data_dir();
	if (args != []):
		work_dir_arg = args[0];
	
	$Label2.text = str("User data:  ", user_data);
	$Label3.text = str("Executable path:  ", work_dir);
	$Label4.text = str("Arg Work Dir:  ", work_dir_arg);
	$Label5.text = str("CMD Arguments:  ", args);

func _on_Button_pressed():
	OS.execute("thunar", [user_data])

func _on_Button2_pressed():
	OS.execute("thunar", [work_dir])

func _on_Button3_pressed():
	if (work_dir_arg != null):
		OS.execute("thunar", [work_dir_arg])
	else:
		$Button3.text = "error"
