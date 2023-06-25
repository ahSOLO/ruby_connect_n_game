# Keeps track of board size and state of each tile
class Board
  def initialize(width, height)
    @tiles = []
    for i in 1..height do
      @tiles.push [TileState::EMPTY] * width
    end
    @presenter = BoardPresenter.new(self)
  end

  def present()
    @presenter.present(@tiles)
  end

  def make_move(player, column)
    for i in 0..GamePrefs::BOARD_HEIGHT - 1 do
      if @tiles[i][column] != TileState::EMPTY
        if i == 0
          return nil
        else
          update_tile(i - 1, column, player)
          return [i-1, column]
        end
      elsif i == GamePrefs::BOARD_HEIGHT - 1
        update_tile(GamePrefs::BOARD_HEIGHT - 1, column, player)
        return [GamePrefs::BOARD_HEIGHT - 1, column]
      end
    end
  end

  def tally_disks(player, row, column, direction)
    startRow = row
    startColumn = column
    count = 1

    case direction
    when WinDirections::HORIZONTAL
      while startColumn > 0 && @tiles[startRow][startColumn - 1] == player
        startColumn = startColumn - 1
      end
      while startColumn < @tiles[0].length() - 1 && @tiles[startRow][startColumn + 1] == player
        startColumn = startColumn + 1
        count += 1
      end
    when WinDirections::DIAG_LEFT_TO_RIGHT
      while startRow > 0 && startColumn > 0 && @tiles[startRow - 1][startColumn - 1] == player
        startRow = startRow - 1
        startColumn = startColumn - 1
      end
      while startRow < @tiles.length() - 1 && startColumn < @tiles[0].length() - 1 && @tiles[startRow + 1][startColumn + 1] == player
        startRow = startRow + 1
        startColumn = startColumn + 1
        count += 1
      end
    when WinDirections::VERTICAL
      while startRow > 0 && @tiles[startRow - 1][startColumn] == player
        startRow = startRow - 1
      end
      while startRow < @tiles.length() - 1 && @tiles[startRow + 1][startColumn] == player
        startRow = startRow + 1
        count += 1
      end
    when WinDirections::DIAG_RIGHT_TO_LEFT
      while startRow > 0 && startColumn < @tiles[0].length() -1 && @tiles[startRow - 1][startColumn + 1] == player
        startRow = startRow - 1
        startColumn = startColumn + 1
      end
      while startRow < @tiles.length() -1 && startColumn > 0 && @tiles[startRow + 1][startColumn - 1] == player
        startRow = startRow + 1
        startColumn = startColumn - 1
        count += 1
      end
    end
    return count
  end

  def check_for_tie()
    for i in 0..GamePrefs::BOARD_WIDTH - 1 do
      if @tiles[0][i] == TileState::EMPTY
        return false
      end
    end
    return true
  end

  private 

  def update_tile(row, column, tilestate)
    @tiles[row][column] = tilestate
  end
end

# Responsible for presenting the board onto the console
class BoardPresenter
  def initialize(board)
    @board = board
  end
  
  def present(tiles)
    tiles.each do |row|
      p row
    end
    puts ""
  end
end