defmodule Mix.Tasks.Brainfuck.Hello do
  use Mix.Task

  def run(args) do
    Mix.shell.info "hello"
    Mix.shell.info inspect(args)
  end
end