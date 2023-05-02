class GameBoard
  @@board = Array.new(3) { Array.new(3, '-') }

  def self.show_board
    @@board.each { |row| puts row.join(' ')}
  end
end

class Player
  attr_reader :symbol

  def initialize(symbol)
    @symbol = symbol
  end

  def place_symbol
    coordinate1, coordinate2 = gets.chomp.split(',')
  end
end

player_1 = Player.new('X')
player_2 = Player.new('O')
GameBoard.show_board