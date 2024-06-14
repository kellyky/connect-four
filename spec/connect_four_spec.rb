# frozen_string_literal: true

require './lib/connect_four'
require 'pry-byebug'

RSpec.describe ConnectFour do
  subject(:game) { described_class.new }
  before { allow(game).to receive(:gets).and_return('1' ) }

  describe '.new_game' do
    it 'should make a new instance and call #play' do
      expect(described_class).to receive(:new).and_return(game)
      expect(game).to receive(:play)
      described_class.new_game
    end
  end

  describe '#play' do
    it 'should call player_turn' do
      allow(game).to receive(:game_won?).and_return(false)
      expect(game).to receive(:player_turn)
      game.play
    end
  end

  describe '#game_won?' do
    context 'when there are 4 in a row - horizontally' do
      before { allow(game).to receive(:horizontal?).and_return(true) }

      it 'should be true' do
        expect(game.game_won?).to eq(true)
      end
    end

    context 'when there are 4 in a row - vertically' do
      it 'should be true' do
        allow(game).to receive(:horizontal?).and_return(false)
        allow(game).to receive(:vertical?).and_return(true)
        expect(game.game_won?).to eq(true)
      end
    end

    # FIXME - maybe! I havne't written the code for this yet
    context 'when there are 4 in a row - diagonally' do
      xit 'should be true' do
        allow(game).to receive(:horizontal?).and_return(false)
        allow(game).to receive(:vertical?).and_return(false)
        allow(game).to receive(:diagonal?).and_return(true)
        expect(game.game_won?).to eq(true)
      end
    end

    describe '#vertical?' do
      let(:board) do
          {
            2 => [{ :red => 4 }],
            3 => [{ :blue => 3 }]
          }
      end

      before { game.instance_variable_set(:@board, board) }
      context 'when there are indeed 4' do
        it 'should be true' do
          expect(game.vertical?(2)).to eq(true)
        end
      end

      context 'when there are LESS than 4' do
        it 'should be false' do
          expect(game.vertical?(3)).to eq(false)
        end
      end
    end

    describe '#horizontal?' do
      before { game.instance_variable_set(:@board, board) }
      context 'when there ARE 4' do
        let(:board) do
            { # TODO: update this - for true case, and create a false case
              0 => [{ :red => 2 }, { :blue => 1 }],
              1 => [{ :blue => 4 }, { :blue => 2 }],
              2 => [{ :red => 4 }, { :blue => 2 }],
              3 => [{ :red => 1 }, { :blue => 2 }],
            }
        end

        it 'should be true' do
          expect(game.horizontal?).to be(true)
        end
      end
    end

    context 'when there are NOT 4 in a row' do
      before { game.instance_variable_set(:@board, board) }
      let(:board) do
            {
              0 => [{ :red => 1 }, { :red => 2 }],
              1 => [{ :blue => 1 }, { :blue => 2 }],
              2 => [{ :red => 2 }, { :blue => 2 }],
              5 => [{ :red => 1 }, { :blue => 2 }],
            }
      end
      it 'should be false' do
        expect(game.horizontal?(0)).to be(false)
      end
    end
  end

  # TODO - write test coverage and functionality
  describe '#diagonal?' do
    context 'when there are 4 in a row - diagonally' do
      before { game.instance_variable_set(:@board, board) }
      let(:board) do
          {
            0 => [{ :red => 1 }, { :blue => 2 }],
            1 => [{ :blue => 1 }, { :red => 2 }, { :red => 1 }, { :blue => 2 }],
            2 => [{ :red => 1 }, { :blue => 1 }, { :red => 1 }, { :blue => 2 }],
            3 => [{ :blue => 1 }, { :red => 3 }],
          }
      end
      xit 'should be true' do
        expect(game.game_won?).to eq(true)
      end
    end

  end

  describe '#player_turn' do
    # FIXME
    xit 'should prompt the first player to place a token' do
      message = "Place your token - tell me the column number." \
        " Columns start at '0' on the left and go up to '6' on" \
        " the right.\n"

      expect { game.play }.to output(message).to_stdout
    end

    it 'should call player_choice' do
      expect(game).to receive(:player_choice)
      game.player_turn
    end

    it 'should call place_token with the token column' do
      column = "3"
      allow(game).to receive(:gets).and_return(column)
      expect(game).to receive(:place_token).with(column)
      game.player_turn
    end

    it 'should change players (update @token_color)' do
      expect { game.player_turn }.to change { game.instance_variable_get(:@token_color) }.from(:red).to(:blue)
    end
  end

  describe '#place_token' do
    let(:column) { "3" }
    let(:token_color) { :red }

    before { allow(game).to receive(:gets).and_return(column) }

    context 'when column was previously EMPTY' do
      it 'pushes a new hash with that color with value of 1' do
        board_column = game.instance_variable_get(:@board)[column.to_i]
        expect { game.place_token(column) }.to change { board_column }.from([]).to([{:red=>1}] )
      end
    end

    context 'when previous token was a DIFFERENT color' do
      it 'pushes a new hash with that color with value of 1' do
        token_color = game.instance_variable_set(:@token_color, :blue)
        board = game.instance_variable_set(:@board, { 3=>[{:red=>1}] })

        board_column = game.instance_variable_get(:@board)[column.to_i]
        expect { game.place_token(column) }.to change { board_column }.from([{ red: 1 }]).to([{:red=>1}, {:blue=>1}])
      end
    end

    context 'when previous token was the SAME color' do
      it 'INCREMENTS the existing count in that column for that color' do
        token_color = game.instance_variable_set(:@token_color, :red)
        board = game.instance_variable_set(:@board, { 3=>[{:red=>1}] })

        board_column = game.instance_variable_get(:@board)[column.to_i]
        expect { game.place_token(column) }.to change { board_column }.from([{ red: 1 }]).to([{:red=>2}])
      end
    end
  end

  describe '#create_grid' do
    it 'should be a hash' do
      expect(subject.create_grid.is_a?(Hash)).to be(true)
    end

    it 'should have 7 keys' do
      expect(subject.create_grid.keys.count).to eq(7)
    end
  end
end
