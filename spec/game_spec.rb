require 'tictactoe'

describe Game do
  let(:player_one) { instance_double(Player, { symbol: 'X', name: 'Player One' }) }
  let(:player_two) { instance_double(Player, { symbol: 'O', name: 'Player Two' }) }
  subject(:game_board) { described_class.new(player_one, player_two) }

  describe '#player_turn(player)' do
    context 'when player gives a valid placement' do
      before do
        allow(game_board).to receive(:show_board)
        allow(player_one).to receive(:turn).and_return([0, 0])
      end

      it 'places a symbol on the board' do
        tiles = game_board.instance_variable_get(:@board)
        expect { game_board.player_turn(player_one) }.to change { tiles[0][0] }.from('-').to('X')
      end
    end

    context 'when player gives an invalid placement once' do
      before do
        allow(game_board).to receive(:show_board)
        allow(player_one).to receive(:turn).and_return([0, 0], [1, 2])
        allow(game_board).to receive(:valid_placement?).and_return(false, true)
      end

      it 'prompts the player again one more time to give a valid placement' do
        expect(player_one).to receive(:turn).twice
        game_board.player_turn(player_one)
      end
    end
  end

  describe '#valid_placement?(coords)' do
    context 'when given valid placement' do
      it 'returns true' do
        coords = [0, 0]
        validity = game_board.valid_placement?(coords)
        expect(validity).to be true
      end
    end

    context 'when placement given is already occupied' do
      let(:coords) { [0, 0] }

      before do
        allow(game_board).to receive(:puts)
        tiles = game_board.instance_variable_get(:@board)
        tiles[0][0] = 'X'
      end

      it 'sends the invalid message' do
        invalid_placement_message = "~~~~Invalid placement~~~~\n \n"
        expect(game_board).to receive(:puts).with(invalid_placement_message)
        game_board.valid_placement?(coords)
      end

      it 'returns false' do
        validity = game_board.valid_placement?(coords)
        expect(validity).to be false
      end
    end
  end

  describe '#someone_win_row?' do
    let(:tiles) { game_board.instance_variable_get(:@board) }

    context 'when all rows is not yet filled' do
      it 'returns false' do
        result = game_board.someone_win_row?
        expect(result).to be false
      end
    end

    context 'when any row contains "_" symbol and is filled' do
      it 'returns false' do
        tiles[2][2] = 'X'
        result = game_board.someone_win_row?
        expect(result).to be false
      end
    end

    context 'when any row is all filled with player symbols' do
      context 'when the player symbols belong to only one player' do
        before do
          allow(game_board).to receive(:set_winner)
          tiles[2].map! { |_tile| 'X' }
        end

        it 'returns true' do
          result = game_board.someone_win_row?
          expect(result).to be true
        end

        it 'calls #set_winner' do
          index = 2
          expect(game_board).to receive(:set_winner).with('row', index)
          game_board.someone_win_row?
        end
      end

      context 'when the player symbols belong to both players' do
        before do
          index = 0
          tiles[1].map! do |_tile|
            index += 1
            index.even? ? 'X' : 'O'
          end
        end

        it 'returns false' do
          result = game_board.someone_win_row?
          expect(result).to be false
        end
      end
    end
  end

  describe '#someone_win_column?' do
    let(:tiles) { game_board.instance_variable_get(:@board) }

    context 'when all columns is not yet filled' do
      it 'returns false' do
        result = game_board.someone_win_column?
        expect(result).to be false
      end
    end

    context 'when any column contains "_" symbol and is filled' do
      it 'returns false' do
        tiles[1][2] = 'X'
        result = game_board.someone_win_column?
        expect(result).to be false
      end
    end

    context 'when any column is all filled with player symbols' do
      context 'when the player symbols belong to only one player' do
        before do
          allow(game_board).to receive(:set_winner)
          count = 2
          until count.negative?
            tiles[count][2] = 'X'
            count -= 1
          end
        end

        it 'returns true' do
          result = game_board.someone_win_column?
          expect(result).to be true
        end

        it 'calls #set_winner' do
          index = 2
          expect(game_board).to receive(:set_winner).with('column', index)
          game_board.someone_win_column?
        end
      end

      context 'when the player symbols belong to both players' do
        before do
          count = 2
          until count.negative?
            tiles[count][1] = count.even? ? 'X' : 'O'
            count -= 1
          end
        end

        it 'returns false' do
          result = game_board.someone_win_column?
          expect(result).to be false
        end
      end
    end
  end

  describe '#someone_win_diagonal?' do
    let(:tiles) { game_board.instance_variable_get(:@board) }

    context 'when all diagonals is not yet filled' do
      it 'returns falsy' do
        result = game_board.someone_win_diagonal?
        expect(result).to be_falsy
      end
    end

    context 'when any diagonal contains "_" symbol and is filled' do
      it 'returns falsy' do
        tiles[1][1] = 'X'
        result = game_board.someone_win_diagonal?
        expect(result).to be_falsy
      end
    end

    context 'when any diagonal is all filled with player symbols' do
      context 'when the player symbols belong to only one player' do
        before do
          allow(game_board).to receive(:set_winner)
          tiles[0][0] = 'X'
          tiles[1][1] = 'X'
          tiles[2][2] = 'X'
        end

        it 'returns truthy' do
          result = game_board.someone_win_diagonal?
          expect(result).to be_truthy
        end

        it 'calls #set_winner' do
          winner_index = 0
          expect(game_board).to receive(:set_winner).with('diagonal', winner_index)
          game_board.someone_win_diagonal?
        end
      end

      context 'when the player symbols belong to both players' do
        before do
          tiles[0][0] = 'X'
          tiles[1][1] = 'O'
          tiles[2][2] = 'X'
        end

        it 'returns falsy' do
          result = game_board.someone_win_diagonal?
          expect(result).to be_falsy
        end
      end
    end
  end

  describe '#set_winner' do
    context 'when setting @winner' do
      before do
        allow(game_board).to receive(:symbol_owner).and_return(player_one.name)
      end

      it 'sets @winner for row-direction' do
        winner_name = 'Player One'
        expect { game_board.set_winner('row', 0) }.to change {
                                                        game_board.instance_variable_get(:@winner)
                                                      }.from(nil).to(winner_name)
      end

      it 'sets @winner for column-direction' do
        winner_name = 'Player One'
        expect { game_board.set_winner('column', 0) }.to change {
                                                           game_board.instance_variable_get(:@winner)
                                                         }.from(nil).to(winner_name)
      end

      it 'sets @winner for diagonal-direction' do
        winner_name = 'Player One'
        expect { game_board.set_winner('row', 0) }.to change {
                                                        game_board.instance_variable_get(:@winner)
                                                      }.from(nil).to(winner_name)
      end
    end
  end

  describe '#symbol_owner' do
    it 'returns player one\'s name' do
      player_symbol = 'X'
      result = game_board.symbol_owner(player_symbol)
      expect(result).to eq(player_one.name)
    end

    it 'returns player two\'s name' do
      player_symbol = 'O'
      result = game_board.symbol_owner(player_symbol)
      expect(result).to eq(player_two.name)
    end
  end
end
