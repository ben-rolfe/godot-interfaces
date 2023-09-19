class_name MyClass
extends Node3D

var my_interface_property:int
# If the interface doesn't specify a type, we can't specify one here, either.
var my_built_in_interface_property

static func _static_init():
	Interface.implement(MyClass, MyInterface)
	# Alternatively, you can define an interface as a built-in class of the Interface class, and implement it like so:
	Interface.implement(MyClass, Interface.MyBuiltInInterface)

func _init():
	# This is how we check if the script on an object (in this case, self) applies an interface
	if Interface.implements(self, MyInterface):
		print("Hooray!")
	# Note that we can also check a script directly, if we prefer:
	print(Interface.implements(self.get_script(), MyInterface))
	print(Interface.implements(MyClass, MyInterface))

func my_interface_method(my_int:int, my_str:String = "this default value is different to the implemented interface, and that's okay")->bool:
	return false
	
# If the interface doesn't specify a return type, we can't specify one here, either. However, there's nothing to stop us from returning a value within the function body, if we wish.
func my_built_in_interface_method():
	return 42
