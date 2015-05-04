defmodule Conway.BoardServer do
  use GenServer

  @interval 1000

  def start_link([height: height, width: width]) do
    empty_cells = Enum.map 1..(height*width), fn _ -> false end
    board = %Conway.Board{cells: empty_cells, height: height, width: width}

    :erlang.start_timer(@interval, __MODULE__, :tick)
    GenServer.start_link(__MODULE__, board, name: __MODULE__)
  end

  def current_board do
    GenServer.call __MODULE__, :current_board
  end

  def activate_cells(cell_coordinates) do
    GenServer.cast __MODULE__, {:activate_cells, cell_coordinates}
  end

  # GenServer implentation

  def handle_cast({:activate_cells, cell_coordinates}, board) do
    {:noreply, Conway.Board.activate_cells(board, cell_coordinates)}
  end

  def handle_call(:current_board, {_from, _ref}, board) do
    {:reply, board, board}
  end

  def handle_info(msg, board) do
    :erlang.start_timer(@interval, self(), :tick)
    {:noreply, Conway.Board.next_board(board)}
  end
end
