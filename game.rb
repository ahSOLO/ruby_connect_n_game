# Keeps track of game state, checks for winner of each match, keeps score, and ends the game when players signal they no longer wish to continue
class Game
  def initialize
    @scores = [0,0]
    @game_state = GameState::INIT
    @current_player = 1
    @in_progress = true
    @winner = nil
  end

  def game_start
    while (@in_progress)
      game_loop()
    end
  end

  private

  def game_loop
    case @game_state
    when GameState::INIT
      start_match()
      @game_state = GameState::PLAYER_INPUT

    when GameState::PLAYER_INPUT
      print_board()
      puts "Player #{@current_player}, choose a column to drop your disk into."
      @input = get_input()
      @game_state = GameState::UPDATE_BOARD

    when GameState::UPDATE_BOARD
      @last_move = make_move(@current_player, *@input - 1)
      if (@last_move == nil)
        puts "That move is not valid, please choose another column"
        @game_state = GameState::PLAYER_INPUT
      else
        if (check_for_winner(@current_player, *@last_move))
          @winner = @current_player
          @scores[@winner - 1] += 1
          @game_state = GameState::WIN_SCREEN
        elsif (check_for_tie())
          @game_state = GameState::WIN_SCREEN
        else
          @current_player = @current_player % 2 + 1
          @game_state = GameState::PLAYER_INPUT
        end
      end

    when GameState::WIN_SCREEN
      if (@winner == nil)
        puts "The players have tied!"
      else
        puts "Player #{@winner} has won the match!"
      end
      puts "Play another round? (y/n)"
      play_another = gets.chomp()
      if play_another.downcase == 'y'
        @game_state = GameState::INIT
      else
        puts "Final Score: Player 1 = #{@scores[0]}; Player 2 = #{@scores[1]}"
        @in_progress = false
      end

    end
  end

  def start_match
    @winner = nil
    @board = Board.new(GamePrefs::BOARD_WIDTH, GamePrefs::BOARD_HEIGHT)
  end

  def print_board
    if (@board != nil)
      @board.present()
    end
  end

  def get_input
    input = Integer(gets.chomp())
    while (input > GamePrefs::BOARD_WIDTH || input <= 0)
      puts "That is not a valid column, please try again."
      input = Integer(gets.chomp())
    end
    return input
  end

  def make_move(player, column)
    if (@board != nil)
      @board.make_move(player, column)
    end
  end

  def check_for_winner(player, row, column)
    highest = 0
    highest = max(highest, @board.tally_disks(player, row, column, WinDirections::HORIZONTAL))
    highest = max(highest, @board.tally_disks(player, row, column, WinDirections::DIAG_LEFT_TO_RIGHT))
    highest = max(highest, @board.tally_disks(player, row, column, WinDirections::VERTICAL))
    highest = max(highest, @board.tally_disks(player, row, column, WinDirections::DIAG_RIGHT_TO_LEFT))
    return highest >= GamePrefs::N_TO_CONNECT
  end

  def check_for_tie()
    return @board.check_for_tie
  end
end