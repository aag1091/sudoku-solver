class HomeController < ApplicationController

  def index
    @puzzle = Sudoku.new(1).puzzle
    @result = Sudoku.new(1).result
  end

end
