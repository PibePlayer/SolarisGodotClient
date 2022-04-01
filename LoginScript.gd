extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Button_pressed():
	print("ButtonPressed");
	if($txt_Username.text != null && $txt_password != null):
		var headers = ["Content-Type: application/json"]
		var data = {
			"email": $txt_Username.text,
			"password": $txt_password.text
		};
		print(data);
		$HTTPRequest.request("http://api.solaris.games/api/auth/login", headers, false, HTTPClient.METHOD_POST, to_json(data));
		$Button.disabled = true;
	else:
		$lbl_NombreUsuario.text = "It's Empty";
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	print(result);
	print(response_code);
	print(headers);
	print(JSON.print(body.get_string_from_ascii(), "\t"));
	var response = JSON.parse(body.get_string_from_ascii()).result;
	if(response.has("errors")):
		print("Error");
		$Button.disabled = false;
	else:
		print("Success");
		var cookies = PoolStringArray();
		for h in headers:
			if h.to_lower().begins_with("set-cookie"):
				cookies.append(h.split(":", true, 1)[1].strip_edges().split("; ")[0]);
				
				print(cookies);
				
		SceneSwitcher.change_scene("Logged", {
			"Username" : response.username,
			"Credits" : response.credits,
			"Cookie" : PoolStringArray(["Cookie: %s" % cookies.join("; ")])
			});
	pass;
