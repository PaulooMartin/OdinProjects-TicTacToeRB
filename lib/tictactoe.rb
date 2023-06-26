class Game
  def initialize(player1, player2)
    @board = Array.new(3) { Array.new(3, '-') }
    @player1 = player1
    @player2 = player2
    @winner = nil
  end

  def show_board
    puts "\n"
    @board.each { |row| puts row.join(' ') }
    puts "\n"
  end

  def start_game
    turns = 0
    until @winner
      turns += 1
      player_turn(@player1)
      win_already = check_winner if turns > 2
      break if breaker(win_already, turns)

      player_turn(@player2)
      check_winner if turns > 2
    end
    show_board
    puts @winner ? "Congratulations #{@winner}, you won!" : 'It\'s a tie!'
  end

  # private

  def player_turn(player)
    show_board
    coords = player.turn
    coords = player.turn until valid_placement?(coords)
    @board[coords[0]][coords[1]] = player.symbol
  end

  def valid_placement?(coords)
    check = @board[coords[0]][coords[1]].include?('-')
    puts "~~~~Invalid placement~~~~\n \n" unless check
    check
  end

  def check_winner
    return true if someone_win_row?

    return true if someone_win_column?

    return true if someone_win_diagonal?
  end

  def someone_win_row?
    index = -1
    is_win = @board.any? do |row|
      index += 1
      next if row[0] == '-'

      row.all? { |symbol| symbol == row[0] }
    end
    set_winner('row', index) if is_win
    is_win
  end

  def someone_win_column?
    flattened = @board.flatten
    index = -1
    is_win = flattened[0..2].any? do |column_sym|
      index += 1
      next if column_sym == '-'

      column_sym == flattened[index + 3] && column_sym == flattened[index + 6]
    end
    set_winner('column', index) if is_win
    is_win
  end

  def someone_win_diagonal?
    flattened = @board.flatten
    winner_index = nil
    return false if flattened[4] == '-'

    winner_index = 0 if flattened[0] == flattened[4] && flattened[0] == flattened[8]
    winner_index = 2 if flattened[2] == flattened[4] && flattened[2] == flattened[6]
    set_winner('diagonal', winner_index) if winner_index
    winner_index # returns truthy/falsy
  end

  def set_winner(direction, index)
    case direction
    when 'row'
      @winner = symbol_owner(@board[index][0])
    when 'column'
      @winner = symbol_owner(@board[0][index])
    when 'diagonal'
      @winner = symbol_owner(@board[0][index])
    end
  end

  def symbol_owner(player_symbol)
    @player1.symbol == player_symbol ? @player1.name : @player2.name
  end

  def breaker(win_already, rounds)
    true if win_already || rounds == 5
  end
end

class Player
  attr_reader :symbol, :name

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end

  def turn
    grab_coordinates
  end

  private

  def grab_coordinates
    coordinates = []
    until valid_coords?(coordinates)
      puts "#{@name}'s turn (Type in the coordinates: '1-3,1-3')"
      coordinates = gets.chomp.split(',')
    end
    coordinates.map { |coords| coords.to_i - 1 }
  end

  def valid_coords?(coordinates)
    return false if coordinates.empty?

    check = coordinates.length == 2
    check2 = coordinates.all? { |coord| coord.match(/^\d$/) }
    check3 =
      coordinates.all? do |coord|
        (coord.to_i < 4) && (coord.to_i >= 1)
      end
    check && check2 && check3
  end
end

player1 = Player.new('Player one', 'X')

# player1.grab_coordinates
# player2 = Player.new('Player two', 'O')
# game_board = Game.new(player1, player2)

# game_board.start_game
