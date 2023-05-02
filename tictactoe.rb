class Player
  def initialize(symbol)
    @symbol = symbol
  end
end

game_board = Array.new(3) { Array.new(3, '-') }
game_board.each { |row| puts row.join(' ') }

player_1 = Player.new('X')
player_2 = Player.new('O')