# frozen_string_literal: true

require 'pry-byebug'

# Game of connect four to play in the command line
class ConnectFour
  MAX_COLUMN_LENTH = 6

  def self.new_game
    new.play
  end

  def initialize
    @board = create_grid
  end

  def play; end

  def create_grid
    grid = {}
    (0...7).each { |i| grid[i] = [] }
    grid
  end
end
