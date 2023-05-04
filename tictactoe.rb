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
    show_board
    player_turn(@player1)
    player_turn(@player2)
  end

  private

  def player_turn(player)
    coords = player.turn
    coords = player.turn until valid_placement?(coords)
    @board[coords[0]][coords[1]] = player.symbol
    show_board
  end

  def valid_placement?(coords)
    check = @board[coords[0]][coords[1]].include?('-')
    puts "~~~~Invalid placement~~~~\n \n" unless check
    check
  end

  def someone_win_row?
    index = -1
    result = @board.any? do |row|
      index += 1
      row.all? { |symbol| symbol == row[0] }
    end
    who_won('row', index) if result
    result
  end

  def someone_win_column?
    flattened = @board.flatten
    index = -1
    result = flattened[0..2].any? do |column_sym|
      index += 1
      column_sym == flattened[index + 3] && column_sym == flattened[index + 6]
    end
    who_won('column', index) if result
    result
  end

  def someone_win_diagonal?
    flattened = @board.flatten
    result = false
    case true
    when flattened[0] == flattened[4] && flattened[0] == flattened[8]
      result = 0
    when flattened[2] == flattened[4] && flattened[2] == flattened[6]
      result = 2
    end
    who_won('diagonal', index) if result
    result
  end

  def who_won(direction, index)
    case direction
    when 'row'

    when 'column'

    when 'diagonal'

    end
  end
end

class Player
  attr_reader :symbol

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
      puts "#{@name}'s turn (Type in the coordinates: '#,#')"
      coordinates = gets.chomp.split(',')
    end
    coordinates.map(&:to_i)
  end

  def valid_coords?(coordinates)
    return false if coordinates.empty?

    check = coordinates.length == 2
    check2 = coordinates.all? { |coord| coord.match(/^\d$/) }
    check3 =
      coordinates.all? do |coord|
        (coord.to_i < 3) && (coord.to_i >= 0)
      end
    check && check2 && check3
  end
end

player1 = Player.new('Player one', 'X')
player2 = Player.new('Player two', 'O')
game_board = Game.new(player1, player2)

# TODO: Until player wins, check who won?
