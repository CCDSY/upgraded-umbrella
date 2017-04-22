defmodule Runtime.LoopExtractorTest do
  use ExUnit.Case, async: true
  alias Brainfuck.Runtime.LoopExtractor
  
  doctest LoopExtractor

  test "extract simple loop" do
    assert {:ok, '>+++<-', '.+.'} = LoopExtractor.extract_loop('[>+++<-].+.')
  end

  test "extract nested loop" do
    assert {:ok, '>+++[>++++<-]<-', '.+.'} = LoopExtractor.extract_loop('[>+++[>++++<-]<-].+.')
  end

  test "fail with open loop" do
    assert {:exit_failure, :open_loop} = LoopExtractor.extract_loop('[>+++<-')
  end

  test "fail with nested open loop" do
    assert {:exit_failure, :open_loop} = LoopExtractor.extract_loop('[>+++[>++<-<-]')
  end
end