@tool
extends Node2D

class_name LPCAnimatedSprite2D

const Framerate:float = 10.0
var AnimationData:Array[LPCAnimationData] = [
	LPCAnimationData.new(3,"IDLE_UP",0,true),
	LPCAnimationData.new(3,"IDLE_LEFT",1,true),
	LPCAnimationData.new(3,"IDLE_DOWN",2,true),
	LPCAnimationData.new(3,"IDLE_RIGHT",3,true),
	LPCAnimationData.new(8,"WALK_UP",4,false),
	LPCAnimationData.new(8,"WALK_LEFT",5,false),
	LPCAnimationData.new(8,"WALK_DOWN",6,false),
	LPCAnimationData.new(8,"WALK_RIGHT",7,false),
	LPCAnimationData.new(8,"RUN_UP",8,false),
	LPCAnimationData.new(8,"RUN_LEFT",9,false),
	LPCAnimationData.new(8,"RUN_DOWN",10,false),
	LPCAnimationData.new(8,"RUN_RIGHT",11,false),
	LPCAnimationData.new(6,"JUMP_UP",12,false),
	LPCAnimationData.new(6,"JUMP_LEFT",13,false),
	LPCAnimationData.new(6,"JUMP_DOWN",14,false),
	LPCAnimationData.new(6,"JUMP_RIGHT",15,false),
	LPCAnimationData.new(3,"EMOTES_UP",16,false),
	LPCAnimationData.new(3,"EMOTES_LEFT",17,false),
	LPCAnimationData.new(3,"EMOTES_DOWN",18,false),
	LPCAnimationData.new(3,"EMOTES_RIGHT",19,false),
	LPCAnimationData.new(3,"SITTING_UP",20,true),
	LPCAnimationData.new(3,"SITTING_LEFT",21,true),
	LPCAnimationData.new(3,"SITTING_DOWN",22,true),
	LPCAnimationData.new(3,"SITTING_RIGHT",23,true),
	LPCAnimationData.new(4,"CLIMB_UP",24,false)
]

@export var SpriteSheets:Array[LPCSpriteSheet]

#yeah, unfortunatly repeating above string list
@export_enum("IDLE_UP",
"IDLE_LEFT",
"IDLE_DOWN",
"IDLE_RIGHT",
"WALK_UP",
"WALK_LEFT",
"WALK_DOWN",
"WALK_RIGHT",
"RUN_UP",
"RUN_LEFT",
"RUN_DOWN",
"RUN_RIGHT",
"JUMP_UP",
"JUMP_LEFT",
"JUMP_DOWN",
"JUMP_RIGHT",
"EMOTES_UP",
"EMOTES_LEFT",
"EMOTES_DOWN",
"EMOTES_RIGHT",
"SITTING_UP",
"SITTING_LEFT",
"SITTING_DOWN",
"SITTING_RIGHT",
"CLIMB_UP") var DefaultAnimation:int
	
enum LPCAnimation {
	IDLE_UP,
	IDLE_LEFT,
	IDLE_DOWN,
	IDLE_RIGHT,
	WALK_UP,
	WALK_LEFT,
	WALK_DOWN,
	WALK_RIGHT,
	RUN_UP,
	RUN_LEFT,
	RUN_DOWN,
	RUN_RIGHT,
	JUMP_UP,
	JUMP_LEFT,
	JUMP_DOWN,
	JUMP_RIGHT,
	EMOTES_UP,
	EMOTES_LEFT,
	EMOTES_DOWN,
	EMOTES_RIGHT,
	SITTING_UP,
	SITTING_LEFT,
	SITTING_DOWN,
	SITTING_RIGHT,
	CLIMB_UP
}

func _ready():
	if Engine.is_editor_hint() == false:
		LoadAnimations()
		
func play(animation: LPCAnimation):
	var sprites = get_children()
	for sprite in sprites:
		sprite.play(AnimationData[animation].Name)

func _notification(what):
	if what == NOTIFICATION_EDITOR_POST_SAVE:
		call_deferred("LoadAnimations")
		
func _enter_tree():
	if Engine.is_editor_hint():
		LoadAnimations()
	

func LoadAnimations():
	var children = get_children();
	for child in children:
		remove_child(child)
		
	for spriteSheet in SpriteSheets:
		var animatedSprite = AnimatedSprite2D.new()
		animatedSprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		var spriteFrames = CreateSprites(spriteSheet.SpriteSheet)
		animatedSprite.frames = spriteFrames
		add_child(animatedSprite)
		if spriteSheet.Name == null || spriteSheet.Name == "":
			animatedSprite.name = "no_name"
		else:
			animatedSprite.name = spriteSheet.Name
		animatedSprite.owner = get_tree().edited_scene_root
		animatedSprite.play(AnimationData[DefaultAnimation].Name)

func CreateSprites(spriteSheet:Texture):
	var spriteFrames = SpriteFrames.new()
	spriteFrames.remove_animation("default")
	for animationIndex in AnimationData.size():
		var data = AnimationData[animationIndex]
		var animationFrameCount = AnimationData[animationIndex].FrameCount
		var animationSpriteRow = AnimationData[animationIndex].Row
		var animationLoop = AnimationData[animationIndex].Loop
		AddAnimation(spriteSheet, spriteFrames, AnimationData[animationIndex])
	return spriteFrames
	
func AddAnimation(spriteSheet:Texture, spriteFrames:SpriteFrames, animationData:LPCAnimationData):
	if spriteSheet == null:
		return
	if spriteFrames.has_animation(animationData.Name):
		spriteFrames.clear(animationData.Name)
	
	spriteFrames.add_animation(animationData.Name)
	for col in range(animationData.FrameCount):
		if "WALK" in animationData.Name && col == 0:
			continue
		var atlasTexture = AtlasTexture.new()
		atlasTexture.atlas = spriteSheet
		atlasTexture.region = Rect2(64*col,64*animationData.Row,64,64)
		spriteFrames.add_frame(animationData.Name, atlasTexture, 0.5)
	spriteFrames.set_animation_loop(animationData.Name, animationData.Loop)
	return spriteFrames
