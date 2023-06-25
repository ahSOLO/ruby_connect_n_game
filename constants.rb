module GamePrefs
  BOARD_WIDTH = 5
  BOARD_HEIGHT = 5
  N_TO_CONNECT = 4
end

module GameState
  INIT = 0
  PLAYER_INPUT = 1
  UPDATE_BOARD = 2
  WIN_SCREEN = 3
end

module WinDirections
  HORIZONTAL = 1
  DIAG_LEFT_TO_RIGHT = 2
  VERTICAL = 3
  DIAG_RIGHT_TO_LEFT = 4
end

module TileState
  EMPTY = 0
  PLAYER1 = 1
  PLAYER2 = 2
end
