class_name Stack

var data:Array

func _init():
	self.data=[]
	
func is_empty():
	return self.data.is_empty()
	
func push(value):
	self.data.append(value)
	
func pop():
	if self.is_empty():
		return
	else:
		return self.data.pop_back()
		
func top():
	if self.is_empty():
		return null
	else:
		return data[-1]

func popInput(value):
	for index in range(data.size()-1,-1,-1):
		if data[index]==value:
			data.remove_at(index)
			break

func has(value):
	return data.has(value)

func size():
	return data.size()

func clear():
	self.data = []
