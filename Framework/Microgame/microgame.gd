## This is the base class that all of your scripts should inherit from. The
## system automatically updates the [member difficulty] value, and you can 
## use this to change your game's difficulty in some way!
##
## To tell the system that the player has won/lost your game, call on the
## [GameManager] class as shown below:
##
## [codeblock]
## # player won the game
## GameManager.win()
##
## # player lost the game
## GameManager.lose()
## [/codeblock]
##
## DANGER: DO NOT EDIT THIS CLASS DIRECTLY. EXTEND OFF OF THE CLASS AS SHOWN IN 
## THE EXAMPLE MICROGAMES. WE WILL NOT ACCEPT MICROGAMES WHICH EDIT THIS CLASS
@abstract class_name MicroGame extends Node

## This is the difficulty modififer for your game, it exists on a scale of 0.0 to 1.0
var difficulty : float = 0.0
