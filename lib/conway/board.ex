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

  def next_cell(true, neighbors) do
    case Enum.count neighbors, &(&1) do
      live_neighbors when live_neighbors < 2 -> false
      live_neighbors when live_neighbors in [2, 3] -> true
      _ -> false
    end
  end

  def next_cell(false, neighbors) do
    case Enum.count neighbors, &(&1) do
      3 -> true
      _ -> false
    end
  end
end
