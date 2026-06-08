@tool
extends RichTextEffect
class_name RichTextShrink

var bbcode := "pop"

func _process_custom_fx(char_fx):
	# 1. Get custom speed from the BBCode tag, default to 2.0
	var speed = char_fx.env.get("speed", 2.0)
	
	# 2. Calculate the scale factor based on time (1.0 down to 0.0)
	var scale_factor = 1.0 - (char_fx.elapsed_time * speed)
	scale_factor = max(scale_factor, 0.0) # Prevent it from going negative
	
	# 3. Define a pivot point (adjust the Y value if characters shift weirdly)
	var pivot := Vector2(0, 0)
	
	# 4. Correct matrix transformation math for scaling around a pivot:
	var t = Transform2D()
	t = t.translated(pivot)
	t = t.scaled(Vector2(scale_factor, scale_factor))
	t = t.translated(-pivot)
	
	# Multiply the new scaling transform into the character's existing transform
	char_fx.transform = char_fx.transform * t
	
	return true
