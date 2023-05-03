class Game
  def initialize(player1, player2)
    @board = Array.new(3) { Array.new(3, '-') }
    @player1 = player1
    @player2 = player2
  end

  def show_board
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
    @board[coords[0].to_i][coords[1].to_i] = player.symbol
    show_board
  end
end

class Player
  attr_reader :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end

  def turn
    coordinates
  end

  private

  def coordinates
    coordinates = []
    until valid_coords?(coordinates)
      puts "#{@name}'s turn (Type in the coordinates: '#,#')"
      coordinates = gets.chomp.split(',')
      valid_coords?(coordinates)
    end
    coordinates
  end

  def valid_coords?(coordinates)
    return false if coordinates.empty?

    check = coordinates.length == 2
    check2 = coordinates.all? { |coord| coord.match(/^\d$/) } # All should be a single digit
    check3 = # All those digits should be < 4
      coordinates.all? do |coord|
        (coord.to_i < 3) && (coord.to_i >= 0)
      end
    check && check2 && check3
  end
end

player1 = Player.new('Player one', 'X')
player2 = Player.new('Player two', 'O')
game_board = Game.new(player1, player2)

game_board.start_game

# TODO: Until player wins, error handling, determine winner
