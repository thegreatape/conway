defmodule Conway.Board do
  @interval 1000

  defstruct cells: [], height: 0, width: 0

  def start_link(board) do
    pid = Agent.start_link(fn -> board end, name: __MODULE__)
    loop
    pid
  end

  def loop do
    receive do
      { :update, coordinates } -> IO.puts coordinates
    after
      @interval ->
        tick
        IO.puts inspect current_board
        loop
    end
  end

  def activate_cells(board, cell_coordinates) do
    Enum.reduce cell_coordinates, board, fn ([ x | [y | []]], board) ->
      set(board, x, y, true)
    end
  end

  def tick do
    Agent.update(__MODULE__, fn (board) -> next_board(board) end)
  end

  def current_board do
    Agent.get(__MODULE__, fn (board) -> board end)
  end

  def neighbors(board, x, y) do
    for x_offset <- -1..1, y_offset <- -1..1, !(x_offset == 0 && y_offset == 0) do
      get(board, rem(x + x_offset, board.width), rem(y + y_offset, board.height))
    end
  end

  def get(%Conway.Board{cells: cells, width: width}, x, y) do
    Enum.at(cells, y * width + x)
  end

  def set(%Conway.Board{cells: cells, height: height, width: width}, x, y, value) do
    new_cells = List.update_at(cells, y * width + x, fn _ -> value end)
    %Conway.Board{cells: new_cells, height: height, width: width}
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

  def next_board(board = %Conway.Board{height: height, width: width}) do
    next_cells = for y <- 0..height-1, x <- 0..width-1 do
      next_cell get(board, x, y), neighbors(board, x, y)
    end
    %Conway.Board{cells: next_cells, height: height, width: width}
  end
end

defimpl Inspect, for: Conway.Board do
  def inspect(board, _opts) do
    rows = for y <- 0..board.height-1 do
      row = for x <- 0..board.width-1 do
        case Conway.Board.get(board, x, y) do
          true  -> "[x]"
          false -> "[ ]"
        end
      end
      Enum.join row, " "
    end
    "#Board height: #{board.height}, width: #{board.width}\n" <> Enum.join rows, "\n"

  end
end
