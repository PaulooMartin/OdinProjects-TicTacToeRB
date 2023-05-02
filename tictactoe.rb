class Game
  def initialize(player1, player2)
    @board = Array.new(3) { Array.new(3, '-') }
    @player1 = player1
    @player2 = player2
  end

  def show_board
    @board.each { |row| puts row.join(' ')}
    puts "\n"
  end

  def game_commence
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
    get_coordinates
  end

  private

  def get_coordinates
    puts "#{@name}'s turn"
    coordinate1, coordinate2 = gets.chomp.split(',')
  end
end

player1 = Player.new('Player 1', 'X')
player2 = Player.new('Player 2', 'O')
game_board = Game.new(player1, player2)

game_board.game_commence