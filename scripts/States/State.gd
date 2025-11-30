extends Node

class State:
	
	var isComplete : bool
	
	var startTime : float
	var time_dict = Time.get_time_dict_from_system()
	var time : float
	
	
	func enter():
		pass
		
	func do():
		pass
		
	func fixed_do():
		pass
	func exit():
		pass
	

	
