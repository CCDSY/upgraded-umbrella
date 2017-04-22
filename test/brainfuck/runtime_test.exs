defmodule RuntimeTest do
  use ExUnit.Case, async: true
  alias Brainfuck.Runtime

  doctest Runtime

  test "simple program no IO no loop" do
    assert {:exit_success, []} = Task.await(Runtime.start_program(">+<<->"))
  end

  test "simple program with IO no loop" do
    assert {:exit_success, 'A'} = Task.await(Runtime.start_program(",.", "A"))
  end

  test "medium program with IO no loop" do
    assert {:exit_success, [1, -1, ?I]} = Task.await(Runtime.start_program(",>+.<<-.>.", "IO"))
  end

  test "exit on unrecognized token in program" do
    assert {:exit_failure, :unknown_token} = Task.await(Runtime.start_program(">+<-hello."))
  end

  test "exit on no input" do
    assert {:exit_failure, :no_input} = Task.await(Runtime.start_program(",,,"))
  end

  test "exit on insufficient input" do
    assert {:exit_failure, :no_input} = Task.await(Runtime.start_program(",,,", "IO"))
  end

  test "simple program with loop" do
    assert {:exit_success, '8'} = Task.await(Runtime.start_program("+++++++[->++++++++<]>."))
  end
end