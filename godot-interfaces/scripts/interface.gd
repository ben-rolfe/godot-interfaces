class_name Interface
extends Object

static var _interfaces:Dictionary = {}

static func implement(cls, interface):
	var interface_properties:Array = interface.get_script_property_list()
	# We ignore the first property, which is named either "Built-in script", or the filename with no path.
	for i in range(1, interface_properties.size()):
		var interface_property = interface_properties[i]
		var implemented:bool = false
		for class_property in cls.get_script_property_list():
			if interface_property.name == class_property.name:
				assert(interface_property.type == class_property.type, "Interface could not be implemented. Class (" + cls.get_path() + ") method property type mismatch: " + class_property.name)
				implemented = true
				break
		assert(implemented, "Interface could not be implemented. Class (" + cls.get_path() + ") lacks required property or there is a type mismatch: " + interface_property.name)
	
	for interface_method in interface.get_script_method_list():
		var implemented:bool = false
		for class_method in cls.get_script_method_list():
			if interface_method.name == class_method.name:
				assert(interface_method.return.type == class_method.return.type, "Interface could not be implemented. Class (" + cls.get_path() + ") method return type mismatch: " + class_method.name)
				assert(interface_method.args == class_method.args, "Interface could not be implemented. Class (" + cls.get_path() + ") method properties differ: " + class_method.name)
				assert(interface_method.default_args.size() == class_method.default_args.size(), "Interface could not be implemented. Class (" + cls.get_path() + ") number of optional arguments differs: " + class_method.name)
				implemented = true
				break
		assert(implemented, "Interface could not be implemented. Class (" + cls.get_path() + ") lacks required method: " + interface_method.name)
	
#	var interface_instance = interface.new()
#	print(interface_instance.get_script().get_script_method_list())

	if _interfaces.has(cls):
		assert(!_interfaces[cls].has(interface), "Interface (" + interface.get_path() + ") has already been implemented on that class (" + cls.get_path() + "). Implement interfaces in _static_init, not for every instance.")
		_interfaces[cls].push_back(interface)
	else:
		_interfaces[cls] = [interface]

static func implements(o, interface) -> bool:
	var cls:Script = o if o is Script else o.get_script()
	return _interfaces.has(cls) and _interfaces[cls].has(interface)


# This is an example of an interface defined within the interfaces script file. It should be accessed like Interfaces.MyInterface. See the my_other_interface.gd file for an alternative.
class MyBuiltInInterface:
	var my_built_in_interface_property

	func my_built_in_interface_method():
		pass
