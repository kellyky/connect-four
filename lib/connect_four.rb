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
    # @winner = nil
  end

  def play
    # TODO: Add call to welcome/greeting/rules

    # TODO: Add logic to loop until there is a winner or board is full
    player_turn
    game_won? ? "Wooo, #{@winner} wins the game!!!" : 'Meh' # temp - TODO: update later
  end

  def create_grid
    (0...7).each_with_object({}) { |i, grid| grid[i] = [] }
  end

  def player_choice
    gets.chomp
  end

  def player_turn
    puts 'Place your token - tell me the column number.' \
      " Columns start at '0' on the left and go up to '6'" \
      " on the right.\n"

    column = player_choice

    place_token(column)

    # TODO: prettier print this
    puts @board

    # At the end of the turn, it changes player
    @token_color = @token_color == :red ? :blue : :red
  end

  def place_token(column)
    @board[column.to_i] << @token_color
  end

  def game_won?
    (0..6).each do |i|
      row = @board.values.map { |tokens| tokens[i] }
      column = @board[i]

      return true if four_in_segment?(row) || four_in_segment?(column)
    end

    diagonal?
  end

  def four_in_segment?(segment)
    return false if segment.count(nil) >= 3

    colors = { red: [], blue: [] }

    segment.each.with_index do |token, i|
      colors[token] << i if token == @token_color
    end.compact

    token_count(colors[@token_color]) == 4
  end

  def token_count(indexes)
    consecutive_tokens = 1
    last_consecutive_token_place = indexes.first

    indexes.each do |token_place|
      next if token_place == indexes.first

      if token_place - last_consecutive_token_place == 1
        consecutive_tokens += 1
        last_consecutive_token_place += 1
      end
    end

    consecutive_tokens
  end

  def diagonal?
    lower_left_to_upper_right_vertical? ||
      upper_left_to_lower_right_vertical? ||
      upper_left_to_lower_right_horizontal? ||
      lower_left_to_upper_right_horizontal?
  end

  # LL to UR - Starting coords (0,2) (0,1) (0,0)
  def lower_left_to_upper_right_vertical?
    consecutives = 0
    x = 0
    y = 2

    row_reducer = 2
    while row_reducer >= 0
      while (y - row_reducer) < 5 || x < 6
        break if @board[x][y - row_reducer].nil?

        consecutives += 1 if @board[x][y - row_reducer] == @token_color
        return true if consecutives == 4

        x += 1
        y += 1
      end
      x = 0
      y = 2
      consecutives = 0
      row_reducer -= 1
    end

    false
  end

  # LL to UR - Starting coords (1,0) (2,0) (3,0)
  def lower_left_to_upper_right_horizontal?
    consecutives = 0
    x = 1
    y = 0

    col_booster = 0
    while col_booster < 3
      while (x + col_booster) < 7 && y < 6
        break if @board[x + col_booster][y].nil?

        consecutives += 1 if @board[x + col_booster][y] == @token_color
        return true if consecutives == 4

        x += 1
        y += 1
      end

      x = 1
      y = 0
      consecutives = 0
      col_booster += 1
    end

    false
  end

  # UL to LR - Starting coords (1,5) (2,5) (3,5)
  def upper_left_to_lower_right_horizontal?
    consecutives = 0
    x = 1
    y = 5

    col_booster = 0
    while col_booster < 3
      while (x + col_booster) <= 6 && y >= 0
        break if @board[x + col_booster][y].nil?

        consecutives += 1 if @board[x + col_booster][y] == @token_color
        return true if consecutives == 4

        x += 1
        y -= 1
      end
      x = 1
      y = 5
      consecutives = 0
      col_booster += 1
    end

    false
  end

  # UL to LR - Starting coords (0,3) (0,4) (0,5)
  def upper_left_to_lower_right_vertical?
    consecutives = 0
    x = 0
    y = 3

    row_booster = 0
    while row_booster < 3
      while (x < 4) || (y + row_booster) >= 0
        break if @board[x][y + row_booster].nil?

        consecutives += 1 if @board[x][y + row_booster] == @token_color
        return true if consecutives == 4

        x += 1
        y -= 1
      end

      x = 0
      y = 3
      consecutives = 0
      row_booster += 1
    end

    false
  end
end
