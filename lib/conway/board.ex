defmodule Conway.Board do
  defstruct cells: [], height: 0, width: 0

  def neighbors(board, x, y) do
    for x_offset <- -1..1, y_offset <- -1..1, !(x_offset == 0 && y_offset == 0) do
      get(board, rem(x + x_offset, board.width), rem(y + y_offset, board.height))
    end
  end

  def get(%Conway.Board{cells: cells, width: width}, x, y) do
    Enum.at(cells, y * width + x)
  end
end
