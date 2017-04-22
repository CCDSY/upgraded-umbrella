defmodule Brainfuck do
  @moduledoc """
  Brainfuck application.
  """

  use Application

  def start(_type, _args) do
    Brainfuck.Runtime.Supervisor.start_link
  end
  
end
