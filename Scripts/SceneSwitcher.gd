extends Node;

var _params = null;

func change_scene(next_scene, params = null):
	_params = params;

	if(next_scene.right(5) != ".tscn"):
		next_scene += ".tscn";

	var _error = get_tree().change_scene(next_scene);

	if(_error):
		print(_error);
	pass;

func get_param(name):
	if(_params != null && _params.has(name)):
		return _params[name];
	pass;
