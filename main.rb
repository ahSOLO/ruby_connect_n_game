# Board X wide, Y tall
# Two players, alternating. P1 starts first.
# Goal is to connect N disks of a player's color in a row
# When placing a disk, it falls down to the first empty spot

# Every turn, after a disk has been placed, do a check in all directions starting from the dot's position

require './game.rb'
require './board.rb'
require './utility.rb'
require './constants.rb'

game = Game.new()
game.game_start()


