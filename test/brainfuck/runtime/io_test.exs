defmodule Runtime.IOTest do
  use ExUnit.Case, async: true
  alias Brainfuck.Runtime.IO

  test "output with no input" do
    assert IO.output(%IO{}) == ""
  end

  test "output with empty input" do
    assert IO.output(%IO{}) == ""
  end

  test "read" do
    io = IO.set_input(%IO{}, "IO")
    assert {?I, io} = IO.read(io)
    assert {?O, _} = IO.read(io)
  end

  test "read insufficient inputs" do
    io = IO.set_input(%IO{}, "IO")
    assert {?I, io} = IO.read(io)
    assert {?O, io} = IO.read(io)
    assert {nil, _} = IO.read(io)
  end

  test "read no input" do
    assert {nil, _} = IO.read(%IO{})
  end

  test "write" do
    assert %IO{}
    |> IO.write(?I) 
    |> IO.write(?O) 
    |> IO.output == "IO"
  end
end