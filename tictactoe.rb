class Game
  def initialize
    @board = Array.new(3) { Array.new(3, '-') }
  end

  def show
    @board.each { |row| puts row.join(' ')}
  end
end

class Player
  attr_reader :symbol

  def initialize(symbol)
    @symbol = symbol
  end

  def get_coordinates
    coordinate1, coordinate2 = gets.chomp.split(',')
  end
end

game_board = Game.new
player_1 = Player.new('X')
player_2 = Player.new('O')

game_board.show