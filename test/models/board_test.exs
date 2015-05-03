defmodule Conway.BoardTest do
  use ExUnit.Case
  use ShouldI

  setup context do
    cells = [
      "a", "b", "c",
      "d", "e", "f",
      "g", "h", "i"
    ]

    Dict.put context, :board, %Conway.Board{cells: cells, height: 3, width: 3}
  end

  should "get cells by x,y", context do
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

  should "get neighbors of a cell", context do
    neighbors = Conway.Board.neighbors(context.board, 1, 1)
    Enum.each ~w(a b c d f g h i), fn(val) -> assert val in neighbors end
    refute "e" in neighbors
  end

  should "get neighbors at board edges", context do
    neighbors = Conway.Board.neighbors(context.board, 2, 2)
    Enum.each ~w(a b c d e f g h), fn(val) -> assert val in neighbors end
    refute "i" in neighbors

    neighbors = Conway.Board.neighbors(context.board, 0, 0)
    Enum.each ~w(b c d e f g h i), fn(val) -> assert val in neighbors end
    refute "a" in neighbors
  end

  with "next_cell" do
    with "live cells" do
      should "die with fewer than two live neighbors" do
        assert Conway.Board.next_cell(true, [false, false, false, false]) == false
        assert Conway.Board.next_cell(true, [false, false, true, false]) == false
      end

      should "live with two to three live neighbors" do
        assert Conway.Board.next_cell(true, [true, false, true, false]) == true
        assert Conway.Board.next_cell(true, [true, false, true, true]) == true
      end

      should "die with more than three live neighbors" do
        assert Conway.Board.next_cell(true, [true, true, true, true]) == false
      end
    end

    with "dead cells" do
      should "become live with exactly three live neighbors" do
        assert Conway.Board.next_cell(false, [true, true, false, true]) == true
      end

      should "remain dead otherwise" do
        assert Conway.Board.next_cell(false, [true, false, false, true]) == false
      end
    end
  end

  with "next_board" do
    should "return the next board state" do
      blinker_cells = [
        false, false, false, false, false,
        false, false, false, false, false,
        false, true,  true,  true,  false,
        false, false, false, false, false,
        false, false, false, false, false
      ]

      board = %Conway.Board{cells: blinker_cells, width: 5, height: 5}
      next_board = Conway.Board.next_board(board)
      assert next_board.cells == [
        false, false, false, false, false,
        false, false,  true, false, false,
        false, false,  true, false,  false,
        false, false,  true, false, false,
        false, false, false, false, false
      ]
      assert next_board.height == 5
      assert next_board.width == 5
    end
  end

  with "activate_cells" do
    setup context do
      cells = [
        false, false, false,
        false, false, false,
        false, true,  true
      ]

      Dict.put context, :board, %Conway.Board{cells: cells, height: 3, width: 3}
    end

    should "flip the cells to live", context do
      board = Conway.Board.activate_cells(context.board, [[0,0], [1,1], [1,2]])
      assert board.cells == [
        true,  false, false,
        false, true,  false,
        false, true,  true
      ]
    end
  end

end
