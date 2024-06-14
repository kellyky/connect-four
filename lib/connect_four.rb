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
    @token_color = :red
    @winner = nil
  end

  def play
    # TODO: Add call to welcome/greeting/rules

    # TODO: Add logic to loop until there is a winner or... other cases?
    # player_turn
    game_won? ? "Wooo, #{@winner} wins the game!!!" : "Meh"   # temp - TODO: update later
  end

  def game_won?
    (0..6).each do |i|
      # binding.pry

      # HORIZONTAL
      return true if horizontal?(i)

      # VERTICLE
      return true if vertical?(i)

      # # DIAGONAL
      # return true if diagonal?(i)
    end

    false
  end

  def horizontal?(i)
    row = @board.values.map { |colors| colors[i] }

    return false if row.count(nil) >= 4

    reds = []
    blues = []

    row.each.with_index do |color, i|
      reds << i if color == :red
      blues << i if color == :blue
    end.compact

    return true if token_count(reds, :red) >= 4

    return true if token_count(blues, :blue) >= 4

    false
  end

  def vertical?(i)
    col = @board[i]

    return false if col.count(nil) >= 3

    reds = []
    blues = []

    col.each.with_index do |token, i|
      reds << i if token == :red
      blues << i if token == :blue
    end.compact

    return true if token_count(reds, :red) >= 4

    return true if token_count(blues, :blue) >= 4

    false
  end

  def token_count(chonk, color)
    consecutives = 1
    last_consecutive_token_place = chonk.first

    chonk.each do |token_place|
      next if token_place == chonk.first

      if token_place - last_consecutive_token_place == 1
        consecutives += 1
        last_consecutive_token_place += 1
      end
    end

    @winner = color if consecutives >= 4

    consecutives
  end

  def diagonal?(i)

  end

  def player_choice
    gets.chomp
  end

  def player_turn
    puts "Place your token - tell me the column number." \
      " Columns start at '0' on the left and go up to '6'" \
      " on the right.\n"

    column = player_choice

    place_token(column)

    # TODO prettier print this
    puts @board

    # At the end of the turn, it changes player
    @token_color = @token_color == :red ? :blue : :red
  end

  def place_token(column)
    @board[column.to_i] << @token_color
  end

  def create_grid
    grid = {}
    (0...7).each { |i| grid[i] = [] }
    grid
  end
end
