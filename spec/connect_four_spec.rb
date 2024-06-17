# frozen_string_literal: true

require './lib/connect_four'
require 'pry-byebug'

RSpec.describe ConnectFour do
  subject(:game) { described_class.new }
  before { allow(game).to receive(:gets).and_return('1') }

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

  describe '#player_turn' do
    # FIXME
    xit 'should prompt the first player to place a token' do
      message = 'Place your token - tell me the column number.' \
        " Columns start at '0' on the left and go up to '6' on" \
        " the right.\n"

      expect { game.play }.to output(message).to_stdout
    end

    it 'should call player_choice' do
      expect(game).to receive(:player_choice)
      game.player_turn
    end

    it 'should call place_token with the token column' do
      column = '3'
      allow(game).to receive(:gets).and_return(column)
      expect(game).to receive(:place_token).with(column)
      game.player_turn
    end

    it 'should change players (update @token_color)' do
      expect { game.player_turn }.to change { game.instance_variable_get(:@token_color) }.from(:red).to(:blue)
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

  describe '#place_token' do
    let(:column) { '3' }
    let(:token_color) { :red }

    before { allow(game).to receive(:gets).and_return(column) }

    context 'when column was previously EMPTY' do
      it 'pushes a new hash with that color with value of 1' do
        board_column = game.instance_variable_get(:@board)[column.to_i]
        expect { game.place_token(column) }.to change { board_column.length }.from(0).to(1)
      end
    end

    context 'when previous token was a DIFFERENT color' do
      it 'pushes a new hash with that color with value of 1' do
        game.instance_variable_set(:@token_color, :blue)
        game.instance_variable_set(:@board, { 3 => [:red] })

        board_column = game.instance_variable_get(:@board)[column.to_i]
        expect { game.place_token(column) }.to change { board_column }.from([:red]).to(%i[red blue])
      end
    end

    context 'when previous token was the SAME color' do
      it 'INCREMENTS the existing count in that column for that color' do
        game.instance_variable_set(:@token_color, :red)
        game.instance_variable_set(:@board, { 3 => [:red] })

        board_column = game.instance_variable_get(:@board)[column.to_i]
        expect { game.place_token(column) }.to change { board_column }.from([:red]).to(%i[red red])
      end
    end
  end

  describe '#game_won?' do
    context 'when there are 4 in a row - horizontally' do
      before { allow(game).to receive(:four_in_segment?).and_return(true) }

      it 'should be true' do
        expect(game.game_won?).to eq(true)
      end
    end

    context 'when there are 4 in a row - vertically' do
      it 'should be true' do
        allow(game).to receive(:four_in_segment?).and_return(false)
        allow(game).to receive(:four_in_segment?).and_return(true)
        expect(game.game_won?).to eq(true)
      end
    end

    # FIXME: - maybe! I havne't written the code for this yet
    context 'when there are 4 in a row - diagonally' do
      it 'should be true' do
        allow(game).to receive(:horizontal?).and_return(false)
        allow(game).to receive(:vertical?).and_return(false)
        allow(game).to receive(:diagonal?).and_return(true)
        expect(game.game_won?).to eq(true)
      end
    end
  end

  describe '#diagonal?' do
  end

  describe '#lower_left_to_upper_right_vertical?' do
    before do
      game.instance_variable_set(:@board, board)
      game.instance_variable_set(:@token_color, :red)
    end

    context 'when there are 4 consecutive tokens for current player' do
      let(:board) do
        {
          0 => ['', '', ''],
          1 => ['', :red, '', ''],
          2 => ['', '', :red, '', ''],
          3 => ['', '', '', :red],
          4 => ['', '', '', '', :red],
          5 => [],
          6 => []
        }
      end

      it 'should be false' do
        expect(game.lower_left_to_upper_right_vertical?).to be(true)
      end
    end

    context 'when there are NOT 4 consecutive tokens' do
      let(:board) do
        {
          0 => ['', '', ''],
          1 => ['', :red, '', ''],
          2 => ['', '', :red, '', ''],
          3 => ['', '', '', :red],
          4 => ['', '', '', '', :blue],
          5 => [],
          6 => []
        }
      end

      it 'should be false' do
        expect(game.lower_left_to_upper_right_vertical?).to be(false)
      end
    end
  end

  describe '#lower_left_to_upper_right_horizontal?' do
    before do
      game.instance_variable_set(:@board, board)
      game.instance_variable_set(:@token_color, :red)
    end

    context 'when there are 4 consecutive tokens for current player' do
      let(:board) do
        {
          0 => ['', '', ''],
          1 => [:red, '', ''],
          2 => ['', :red, ''],
          3 => ['', '', :red],
          4 => ['', '', '', :red],
          5 => [],
          6 => []
        }
      end

      it 'should be true' do
        expect(game.lower_left_to_upper_right_horizontal?).to be(true)
      end
    end

    context 'when there are NOT 4 consecutive tokens' do
      let(:board) do
        {
          0 => ['', '', ''],
          1 => [:red, '', ''],
          2 => ['', :red, ''],
          3 => ['', '', :red],
          4 => ['', '', '', :blue],
          5 => [],
          6 => []
        }
      end

      it 'should be false' do
        expect(game.lower_left_to_upper_right_horizontal?).to be(false)
      end
    end
  end

  describe '#upper_left_to_lower_right_horizontal?' do
    before do
      game.instance_variable_set(:@board, board)
      game.instance_variable_set(:@token_color, :red)
    end

    context 'when there are 4 consecutive tokens for current player' do
      let(:board) do
        {
          0 => ['', '', '', ''],
          1 => ['', '', '', '', '', :red],
          2 => ['', '', '', '', :red],
          3 => ['', '', '', :red],
          4 => ['', '', :red, ''],
          5 => [],
          6 => []
        }
      end

      it 'should be false' do
        expect(game.upper_left_to_lower_right_horizontal?).to be(true)
      end
    end

    context 'when there are NOT 4 consecutive tokens' do
      let(:board) do
        {
          0 => ['', '', '', ''],
          1 => ['', '', '', '', '', :red],
          2 => ['', '', '', '', :red],
          3 => ['', '', '', :red],
          4 => [],
          5 => [],
          6 => []
        }
      end

      it 'should be false' do
        expect(game.upper_left_to_lower_right_horizontal?).to be(false)
      end
    end
  end

  describe '#upper_left_to_lower_right_vertical?' do
    before do
      game.instance_variable_set(:@board, board)
      game.instance_variable_set(:@token_color, :red)
    end

    context 'when there are 4 consecutive tokens for current player' do
      let(:board) do
        {
          0 => ['', '', '', :red],
          1 => ['', '', :red, ''],
          2 => ['', :red, '', '', ''],
          3 => [:red, '', ''],
          4 => [],
          5 => [],
          6 => []
        }
      end

      it 'should be false' do
        expect(game.upper_left_to_lower_right_vertical?).to be(true)
      end
    end

    context 'when there are NOT 4 consecutive tokens' do
      let(:board) do
        # board has 3 consec red tokens
        {
          0 => ['', '', '', :red],
          1 => ['', '', :red, ''],
          2 => ['', :red, '', '', ''],
          3 => [:blue, '', ''],
          4 => [],
          5 => [],
          6 => []
        }
      end

      it 'should be false' do
        expect(game.upper_left_to_lower_right_vertical?).to be(false)
      end
    end
  end
end
