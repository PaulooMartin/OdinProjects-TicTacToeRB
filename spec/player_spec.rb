require 'tictactoe'

# rubocop:disable Metrics/BlockLength
describe Player do
  subject(:player) { described_class.new('Player 1', 'X') }

  describe '#grab_coordinates' do
    context 'when it receives invalid coordinates once' do
      before do
        invalid = '1,0'
        valid = '1,1'
        allow(player).to receive(:gets).and_return(invalid, valid)
      end

      it 'loops once' do
        expect(player).to receive(:puts).twice
        player.grab_coordinates
      end
    end

    context 'when it receives invalid coordinates 4 times' do
      before do
        invalid_a = '#,2'
        invalid_b = '11,1'
        invalid_c = 'a,a'
        invalid_d = ''
        valid = '3,2'
        allow(player).to receive(:gets).and_return(invalid_a, invalid_b, invalid_c, invalid_d, valid)
      end

      it 'loops 4 times' do
        expect(player).to receive(:puts).exactly(5).times
        player.grab_coordinates
      end
    end

    context 'when it receives valid coordinates' do
      before do
        allow(player).to receive(:puts)
        allow(player).to receive(:gets).and_return('3,2')
      end

      it 'returns an Array' do
        expect(player.grab_coordinates).to be_an(Array)
      end

      it 'returns an Array with two elements' do
        result = player.grab_coordinates.length
        expect(result).to eq(2)
      end
    end
  end

  describe '#valid_coords?' do
    context 'when passing invalid coordinates' do
      context 'when no coordinates are passed' do
        it 'returns false' do
          coordinates = []
          result = player.valid_coords?(coordinates)
          expect(result).to be false
        end
      end

      context 'when coordinates contains more than 2 numbers' do
        it 'returns false' do
          coordinates = %w[1 2 3]
          result = player.valid_coords?(coordinates)
          expect(result).to be false
        end
      end
      context 'when coordinates contains symbol' do
        it 'returns false' do
          coordinates = %w[# 2]
          result = player.valid_coords?(coordinates)
          expect(result).to be false
        end
      end

      context 'when coordinates contains letter/s' do
        it 'returns false' do
          coordinates = %w[1 a]
          result = player.valid_coords?(coordinates)
          expect(result).to be false
        end
      end

      context 'when coordinates contains number greater than 3' do
        it 'returns false' do
          coordinates = %w[4 2]
          result = player.valid_coords?(coordinates)
          expect(result).to be false
        end
      end

      context 'when coordinates contains number less than 1' do
        it 'returns false' do
          coordinates = %w[0 1]
          result = player.valid_coords?(coordinates)
          expect(result).to be false
        end
      end
    end

    context 'when passing valid coordinates' do
      context 'when coordinates is within range' do
        it 'returns true for [smallest,largest]' do
          coordinates = %w[1 3]
          result = player.valid_coords?(coordinates)
          expect(result).to be true
        end

        it 'returns true for [largest, smallest]' do
          coordinates = %w[3 1]
          result = player.valid_coords?(coordinates)
          expect(result).to be true
        end
      end

      context 'when coordinates are same digits' do
        it 'returns true for [1,1]' do
          coordinates = %w[1 1]
          result = player.valid_coords?(coordinates)
          expect(result).to be true
        end

        it 'returns true for [2,2]' do
          coordinates = %w[2 2]
          result = player.valid_coords?(coordinates)
          expect(result).to be true
        end

        it 'returns true for [3,3]' do
          coordinates = %w[3 3]
          result = player.valid_coords?(coordinates)
          expect(result).to be true
        end
      end

      context 'when coordinates are differing digits' do
        it 'returns true for [1,2]' do
          coordinates = %w[1 2]
          result = player.valid_coords?(coordinates)
          expect(result).to be true
        end

        it 'returns true for [3,2]' do
          coordinates = %w[3 2]
          result = player.valid_coords?(coordinates)
          expect(result).to be true
        end
      end
    end
  end
end
