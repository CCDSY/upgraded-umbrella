defmodule Helper.ListTest do
  use ExUnit.Case, async: true
  import Brainfuck.Helper.List

  test "prepend" do
    result = prepend [1, 2, 3], 0
    assert result === [0, 1, 2, 3]
  end

  test "append" do
    result = append [1, 2, 3], 4
    assert result === [1, 2, 3, 4]
  end
end
