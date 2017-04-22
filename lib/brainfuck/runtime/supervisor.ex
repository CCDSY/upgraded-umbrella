defmodule Brainfuck.Runtime.Supervisor do
  use Supervisor

  @name __MODULE__
  
  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  # def start_program(program, input) do
  #   Supervisor.start_child(@name, [program, input])
  # end
  
  def init(:ok) do
    children = [
      # worker(Brainfuck.Runtime, [], restart: :temporary)
      supervisor(Task.Supervisor, [[name: Brainfuck.TaskSupervisor]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end