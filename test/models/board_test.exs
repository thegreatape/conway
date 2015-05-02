defmodule Conway.BoardTest do
  use ExUnit.Case
  setup do
    cells = [
      "a", "b", "c",
      "d", "e", "f",
      "g", "h", "i"
    ]

    {:ok, board: %Conway.Board{cells: cells, height: 3, width: 3} }
  end

  test "getting cell by x,y", context do
    assert Conway.Board.get(context.board, 0, 0) == "a"
    assert Conway.Board.get(context.board, 1, 0) == "b"
    assert Conway.Board.get(context.board, 2, 0) == "c"
    assert Conway.Board.get(context.board, 0, 1) == "d"
    assert Conway.Board.get(context.board, 1, 1) == "e"
    assert Conway.Board.get(context.board, 2, 1) == "f"
    assert Conway.Board.get(context.board, 0, 2) == "g"
    assert Conway.Board.get(context.board, 1, 2) == "h"
    assert Conway.Board.get(context.board, 2, 2) == "i"
  end

  test "neighbors at board edges", context do
    neighbors = Conway.Board.neighbors(context.board, 2, 2)
    Enum.each ~w(a b c d e f g h), fn(val) -> assert val in neighbors end
    refute "i" in neighbors

    neighbors = Conway.Board.neighbors(context.board, 0, 0)
    Enum.each ~w(b c d e f g h i), fn(val) -> assert val in neighbors end
    refute "a" in neighbors
  end

  test "getting neighbors of a cell", context do
    neighbors = Conway.Board.neighbors(context.board, 1, 1)
    Enum.each ~w(a b c d f g h i), fn(val) -> assert val in neighbors end
    refute "e" in neighbors
  end
end
