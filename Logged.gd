extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var headers = SceneSwitcher.get_param("Cookie");
	print(headers);
	$GetActiveGames.request("https://api.solaris.games/api/game/list/active", headers, false, HTTPClient.METHOD_GET);
	$lbl_PlayerName.text = SceneSwitcher.get_param("Username");
	$lbl_Credits.text = "%.f Credits" % SceneSwitcher.get_param("Credits");
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_GetActiveGames_request_completed(result, response_code, headers, body):
	if(response_code != 401):
		#print(JSON.print(body.get_string_from_ascii(), "\t"));
		var response = JSON.parse(body.get_string_from_ascii()).result;
		print(response[0].settings.general.name);
		if(response != null):
			$ActiveGames.add_item("Name");
			$ActiveGames.add_item("Players");
			$ActiveGames.add_item("Last Tick Date");
			$ActiveGames.add_item("Waiting for Input");
			for game in response:
				$ActiveGames.add_item(game.settings.general.name);
				$ActiveGames.add_item("%.f / %.f" % [game.state.players, game.settings.general.playerLimit]);
				if(game.state.paused):
					$ActiveGames.add_item("Paused");
				else:
					$ActiveGames.add_item(game.state.lastTickDate);
				$ActiveGames.add_item("%s" % game.userNotifications.turnWaiting);
	else:
		print("401!!");
	pass # Replace with function body.
