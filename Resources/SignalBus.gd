extends Node2D

#door
signal door_opened(bool,int)
signal button_pressed(bool,int)


#character
signal characterDied(selectionId,entity)
signal characterSelected(selectionId)
signal characterSwap()
signal spawn_slime_from_item_signal(type : Array,modifiers : int,selection_id : int)

#move to next level
signal nextLevel(level_id)

#todo make lich crossable blocks
