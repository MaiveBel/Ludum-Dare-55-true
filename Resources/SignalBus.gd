extends Node2D

#door
signal door_opened(bool,int)
signal button_pressed(bool,int)


#character
signal characterDied(selectionId,entity)
signal characterSelected(selectionId)

#next level
signal nextLevel(level_id)
