defmodule RuntimeTest do
  use ExUnit.Case, async: true
  alias Brainfuck.Runtime

  doctest Runtime

  test "simple program no IO no loop" do
    assert {:exit_success, []} = Task.await(Runtime.start_program_linked(">+<<->"))
  end

  test "simple program with IO no loop" do
    assert {:exit_success, 'A'} = Task.await(Runtime.start_program_linked(",.", "A"))
  end

  test "medium program with IO no loop" do
    assert {:exit_success, [1, -1, ?I]} = Task.await(Runtime.start_program_linked(",>+.<<-.>.", "IO"))
  end

  test "ignore unrecognized tokens in program" do
    assert {:exit_success, [-1]} = Task.await(Runtime.start_program_linked(">+<-hello."))
  end

  test "exit on no input" do
    assert {:exit_failure, :no_input} = Task.await(Runtime.start_program_linked(",,,"))
  end

  test "exit on insufficient input" do
    assert {:exit_failure, :no_input} = Task.await(Runtime.start_program_linked(",,,", "IO"))
  end

  test "simple program with loop" do
    assert {:exit_success, '8'} = Task.await(Runtime.start_program_linked("+++++++[->++++++++<]>."))
  end

  test "simple program with callback" do
    this = self()
    Runtime.start_program(",>,.<.", "IO", fn state -> send this, state end)
    assert_receive {:exit_success, 'OI'}
  end

  test "broken program with open loop with callback" do
    this = self()
    Runtime.start_program("++[>+++<-", fn state -> send this, state end)
    assert_receive {:exit_failure, :open_loop}
  end
end