class Sudoku

  attr_accessor :puzzle

  def initialize(puzzle)
    @puzzle = puzzle
  end

  def puzzle
    # [ 
    #   0, 0, 7, 0, 3, 0, 8, 0, 0,
    #   0, 0, 0, 2, 0, 5, 0, 0, 0,
    #   4, 0, 0, 9, 0, 6, 0, 0, 1,
    #   0, 4, 3, 0, 0, 0, 2, 1, 0,
    #   1, 0, 0, 0, 0, 0, 0, 0, 5,
    #   0, 5, 8, 0, 0, 0, 6, 7, 0,
    #   5, 0, 0, 1, 0, 8, 0, 0, 9,
    #   0, 0, 0, 5, 0, 3, 0, 0, 0,
    #   0, 0, 2, 0, 9, 0, 5, 0, 0
    # ]
    [
      0, 0, 9, 6, 0, 7, 4, 3, 1,
      8, 0, 0, 0, 5, 3, 0, 0, 9,
      0, 6, 0, 2, 0, 0, 5, 0, 0,
      0, 0, 8, 9, 0, 0, 0, 0, 6,
      0, 0, 2, 0, 4, 0, 7, 0, 5,
      0, 0, 0, 0, 0, 1, 0, 0, 0,
      0, 0, 0, 5, 9, 4, 3, 0, 2,
      0, 2, 7, 0, 3, 0, 0, 1, 0,
      4, 0, 0, 1, 0, 2, 6, 5, 0
    ]
    # [
    #   5, 7, 0, 0, 2, 0, 0, 3, 4,
    #   0, 0, 4, 0, 3, 0, 1, 0, 0,
    #   1, 0, 0, 4, 0, 9, 0, 0, 7,
    #   0, 0, 0, 5, 0, 8, 0, 0, 0,
    #   0, 4, 9, 0, 0, 0, 7, 1, 0,
    #   0, 0, 0, 7, 0, 4, 0, 0, 0,
    #   7, 0, 0, 9, 0, 3, 0, 0, 8,
    #   0, 0, 8, 0, 7, 0, 3, 0, 0,
    #   3, 5, 0, 0, 8, 0, 0, 7, 9
    # ]
  end

  def result
    res = puzzle
    25.times do
      9.times do
        res = filling_numbers_comparing_squares_with_vh_lines(res, no_with_most_occurences_at_start(res))
      end
      9.times do |j|
        res = filling_numbers_comparing_v_line_with_squares(res, 9-j)
      end
      9.times do |j|
        res = filling_numbers_comparing_h_line_with_squares(res, 9-j)
      end
    end

    return res
  end

  def filling_numbers_comparing_squares_with_vh_lines(puz, no)
    squares_not_having_most_occuring_no = squares_not_having(puz, no)
    squares_not_having_most_occuring_no.each do |i|
      puz = comparing_squares_with_vh_lines(puz, i, no)
    end
    puz
  end

  def filling_numbers_comparing_v_line_with_squares(puz, no)
    squares_not_having_most_occuring_no = squares_not_having(puz, no)
    squares_not_having_most_occuring_no.each do |i|
      puz = comparing_v_lines_with_squares(puz, i, no)
    end
    puz
  end

  def filling_numbers_comparing_h_line_with_squares(puz, no)
    squares_not_having_most_occuring_no = squares_not_having(puz, no)
    squares_not_having_most_occuring_no.each do |i|
      puz = comparing_h_lines_with_squares(puz, i, no)
    end
    puz
  end

  def squares_not_having(puz, num)
    sqs = []
    9.times do |i|
      sqs << i+1 if !puz.values_at(*eval("sq#{(i+1)}")).include?(num)
    end
    sqs
  end

  def comparing_squares_with_vh_lines(puz, sq_no, num)
    middle_value = eval("sq#{sq_no}[4]")
    vertical_rows = []
    9.times do |i|
      v = eval("v#{(i+1)}")
      vertical_rows << i+1 if !puz.values_at(*v).include?(num) && (v.include?(middle_value-1) || v.include?(middle_value) || v.include?(middle_value+1))
    end
    horizontal_rows = []
    9.times do |i|
      h = eval("h#{(i+1)}")
      horizontal_rows << i+1 if !puz.values_at(*h).include?(num) && (h.include?(middle_value-9) || h.include?(middle_value) || h.include?(middle_value+9))
    end
    
    square_indexes = eval("sq#{sq_no}")
    vertical_indexes = []
    vertical_rows.each do |i|
      vertical_indexes += eval("v#{i}")
    end
    horizontal_indexes = []
    horizontal_rows.each do |i|
      horizontal_indexes += eval("h#{i}")
    end
    possible_places = square_indexes & vertical_indexes & horizontal_indexes
    possible_places.delete_if {|i| puz[i] != 0 }
    
    if possible_places.count < 1
      possible_places = square_indexes & vertical_indexes
      possible_places.delete_if {|i| puz[i] != 0 }
    end
  
    if possible_places.count < 1
      possible_places = square_indexes & horizontal_indexes
      possible_places.delete_if {|i| puz[i] != 0 }
    end

    if possible_places.count == 1 && !puz.values_at(*square_indexes).include?(num)
      puz[possible_places.first] = num
    end
  
    puz
  end

  def comparing_v_lines_with_squares(puz, sq_no, no)
    square_indexes = eval("sq#{sq_no}")
    square_values = puz.values_at(*square_indexes)
    9.times do |i|
      v_line_indexes = eval("v#{(i+1)}")
      possible_places = square_indexes & v_line_indexes
      possible_places.delete_if {|i| puz[i] != 0 }
      v_line_values = puz.values_at(*v_line_indexes)
      already_filled_nos = v_line_values | square_values
      already_filled_nos.delete(0)
      possible_values = all_possible_values - already_filled_nos
      if (i%3) == 0
        v1_line_indexes = eval("v#{(i+2)}")
        v2_line_indexes = eval("v#{(i+3)}")
      elsif (i%3) == 1
        v1_line_indexes = eval("v#{(i)}")
        v2_line_indexes = eval("v#{(i+2)}")
      elsif (i%3) == 2
        v1_line_indexes = eval("v#{(i-1)}")
        v2_line_indexes = eval("v#{(i)}")
      end
      v1_line_values = puz.values_at(*v1_line_indexes)
      v2_line_values = puz.values_at(*v2_line_indexes)
      other_line_common_value = (v1_line_values & v2_line_values)
      remaining_values = other_line_common_value & possible_values
      if possible_places.count == 1
        if remaining_values.count == 1
          puz[possible_places.first] = remaining_values.first
        end
      elsif possible_places.count == 2
        possible_places.each do |j|
          h_line_indexes = nil
          9.times do |k|
            h_line_indexes = eval("h#{(k+1)}") if eval("h#{(k+1)}").include?(j)
          end
          h_line_values = puz.values_at(*h_line_indexes)
          unless h_line_values.include?(no)
            if remaining_values.count == 1
              # puz[j] = remaining_values.first
            end
          end
        end
      end
    end
    puz
  end

  def comparing_h_lines_with_squares(puz, sq_no, no)
    square_indexes = eval("sq#{sq_no}")
    square_values = puz.values_at(*square_indexes)
    9.times do |i|
      h_line_indexes = eval("h#{(i+1)}")
      possible_places = square_indexes & h_line_indexes
      possible_places.delete_if {|i| puz[i] != 0 }
      h_line_values = puz.values_at(*h_line_indexes)
      already_filled_nos = h_line_values | square_values
      already_filled_nos.delete(0)
      possible_values = all_possible_values - already_filled_nos
      if (i%3) == 0
        h1_line_indexes = eval("h#{(i+2)}")
        h2_line_indexes = eval("h#{(i+3)}")
      elsif (i%3) == 1
        h1_line_indexes = eval("h#{(i)}")
        h2_line_indexes = eval("h#{(i+2)}")
      elsif (i%3) == 2
        h1_line_indexes = eval("h#{(i-1)}")
        h2_line_indexes = eval("h#{(i)}")
      end
      h1_line_values = puz.values_at(*h1_line_indexes)
      h2_line_values = puz.values_at(*h2_line_indexes)
      other_line_common_value = (h1_line_values & h2_line_values)
      remaining_values = other_line_common_value & possible_values
      if possible_places.count == 1
        if remaining_values.count == 1
          puz[possible_places.first] = remaining_values.first
        end
      elsif possible_places.count == 2
        puts possible_places.inspect
        puts no.inspect
        possible_places.each do |j|
          v_line_indexes = nil
          9.times do |k|
            v_line_indexes = eval("v#{(k+1)}") if eval("v#{(k+1)}").include?(j)
          end
          puts v_line_indexes.inspect
          v_line_values = puz.values_at(*v_line_indexes)
          puts v_line_values.inspect
          puts '-'*25
          unless v_line_values.include?(no)
            if remaining_values.count == 1
              # puz[j] = remaining_values.first
            end
          end
        end
      end
    end
    puz
  end

  def all_possible_values
    [1,2,3,4,5,6,7,8,9]
  end

  def current_places(puz, num)
    puz.each_index.select{|i| puz[i] == num }
  end

  def no_with_most_occurences_at_start(puz)
    count = []
    9.times do |i|
      count << current_places(puz, i+1).count
    end
    count.map!{ |i| i == 9 ? 0 : i }
    count.each_with_index.max[1]+1
  end

  # private

  def sq1
    [ 0, 1, 2, 9, 10, 11, 18, 19, 20 ]
  end

  def sq2
    [ 3, 4, 5, 12, 13, 14, 21, 22, 23 ]
  end

  def sq3
    [ 6, 7, 8, 15, 16, 17, 24, 25, 26 ]
  end

  def sq4
    [ 27, 28, 29, 36, 37, 38, 45, 46, 47 ]
  end

  def sq5
    [ 30, 31, 32, 39, 40, 41, 48, 49, 50 ]
  end

  def sq6
    [ 33, 34, 35, 42, 43, 44, 51, 52, 53 ]
  end

  def sq7
    [ 54, 55, 56, 63, 64, 65, 72, 73, 74 ]
  end

  def sq8
    [ 57, 58, 59, 66, 67, 68, 75, 76, 77 ]
  end

  def sq9
    [ 60, 61, 62, 69, 70, 71, 78, 79, 80]
  end

  def h1
    (0..8).to_a
  end

  def h2
    (9..17).to_a
  end

  def h3
    (18..26).to_a
  end

  def h4
    (27..35).to_a
  end

  def h5
    (36..44).to_a
  end

  def h6
    (45..53).to_a
  end

  def h7
    (54..62).to_a
  end

  def h8
    (63..71).to_a
  end

  def h9
    (72..80).to_a
  end

  def v1
    [ 0, 9, 18, 27, 36, 45, 54, 63, 72 ]
  end

  def v2
    [ 1, 10, 19, 28, 37, 46, 55, 64, 73 ]
  end

  def v3
    [ 2, 11, 20, 29, 38, 47, 56, 65, 74 ]
  end

  def v4
    [ 3, 12, 21, 30, 39, 48, 57, 66, 75 ]
  end

  def v5
    [ 4, 13, 22, 31, 40, 49, 58, 67, 76 ]
  end

  def v6
    [ 5, 14, 23, 32, 41, 50, 59, 68, 77 ]
  end

  def v7
    [ 6, 15, 24, 33, 42, 51, 60, 69, 78 ]
  end

  def v8
    [ 7, 16, 25, 34, 43, 52, 61, 70, 79 ]
  end

  def v9
    [ 8, 17, 26, 35, 44, 53, 62, 71, 80 ]
  end

end