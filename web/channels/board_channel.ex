defmodule Conway.BoardChannel do
  use Phoenix.Channel

  def broadcast_board(board) do
    Conway.Endpoint.broadcast! "board:state", "update", board
  end

  def join("board:state", _auth_msg, socket) do
    {:ok, socket}
  end

  def handle_in("update", board, socket) do
    broadcast! socket, "update", board
    {:noreply, socket}
  end
end
