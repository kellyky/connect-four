# frozen_string_literal: true

require './lib/connect_four'
require 'pry-byebug'

RSpec.describe ConnectFour do
  subject(:game_instance) { described_class.new }
  describe '.new_game' do
    it 'should make a new instance and call #play' do
      expect(described_class).to receive(:new).and_return(game_instance)
      expect(game_instance).to receive(:play)
      described_class.new_game
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
