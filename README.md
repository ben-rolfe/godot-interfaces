# godot-interfaces
An implementation of interfaces in GDScript.

## Should I use this?
Note that this implementation does *not* follow the best practice guidelines around interfaces recommended by Godot:
https://docs.godotengine.org/en/stable/tutorials/best_practices/godot_interfaces.html

To me, those guidelines reads more like advice on how *not* to use interfaces than how to use them, so this is presented as an alternative for people who want C#-like interfaces that throw errors when they're not properly implemented.

Note also that it's not blazingly fast. The `Interface.implement` calls on startup probably aren't of concern, but each time you check `Interface.implements` there is a dictionary lookup followed by a list lookup (both likely to be small). If you're using GDScript in the first place, then it's probably not going to be an impact that will bother you at all, but it's worth a mention.

## Usage
You only need to copy the `interfaces.gd` script into your project. The rest of the project is for demonstration (you'll also want to delete the `MyBuiltInInterface` class from `interfaces.gd`)

Interfaces are set up as subclasses, or as simple classes that extend Object, with only the properties and methods that the interfaced classes must implement. In the interface itself, these methods should do nothing, and the property values should not be set - Interfaces are never instantiated. (Methods that return a value must include a return command, to avoid an error.)

Interfaces are implemented within a class's `_static_init` method, using `Interface.implement`:
```
class_name MyClass
extends Node3D

static func _static_init():
	Interface.implement(MyClass, MyInterface)
	# Alternatively, you can define an interface as a built-in class of the Interface class, and implement it like so: 
	Interface.implement(MyClass, Interface.MyBuiltInInterface)
```

When `implement` is called, it will enforce that the interface's methods and properties exist in the interfaced class. The following rules will apply:
* For each property in the interface:
    * A property of the same name must exist.
    * It must have the same datatype, if specified, or otherwise also be unspecified.
* For each method in the interface:
    * A method of the same name must exist.
    * The return datatype must be the same, if specified, or otherwise also be unspecified.
    * It must take the same number of parameters.
    * Each parameter must have the same name.
    * Each parameter must have the same datatype, if specified, or otherwise also be unspecified.
    * It must have the same number of optional parameters. The default values do *not* need to match.

To test whether an interface has been implemented on the script on an object (such as a node), use `Interface.implements`:
```
if Interface.implements(MyNode, MyInterface):
    print("Hooray!")
```
You can also pass the script/class itself directly to `Interface.implements`:
```
print(Interface.implements(self.get_script(), MyInterface))
print(Interface.implements(MyClass, MyInterface))
```
