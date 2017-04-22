defmodule Brainfuck.Runtime do
  @moduledoc """
  The runtime of a Brainfuck program. 
  """
  
  import Brainfuck.Runtime.LoopExtractor
  alias Brainfuck.Runtime.Registry
  alias Brainfuck.Runtime.IO
  alias Brainfuck.Runtime

  defstruct registry: %Registry{}, io: %IO{}

  @type exit_reason :: :no_input | :open_loop | :unknown_token | :unexpected_loop_end

  @inc_ptr ?>
  @dec_ptr ?<
  @inc_val ?+
  @dec_val ?-
  @output ?.
  @input ?,
  @loop_start ?[
  @loop_end ?]

  @doc ~S"""
  Start executing the given program asynchronously, (optionally) with the given input. 
  
  Returns a `Task` that's executing the program. 

  The result of the `Task` would be either
  
      {:exit_success, outputs :: charlist}
  
  or
  
      {:exit_failure, reason :: exit_reason}

  ## Examples

      iex> Task.await(Brainfuck.Runtime.start_program(",>,.<.", "IO"))
      {:exit_success, 'OI'}

      iex> Task.await(Brainfuck.Runtime.start_program(",."))
      {:exit_failure, :no_input}

  """
  def start_program(program, input \\ nil) do
    Task.Supervisor.async(Brainfuck.TaskSupervisor, fn -> 
      main String.to_charlist(program), %Runtime{io: IO.set_input(%IO{}, input)}
    end)
  end
  
  defp main(instructions, state) do
    case execute_program(instructions, state) do
      {:ok, state} ->
        {:exit_success, state.io.outputs}
      failure ->
        failure
    end
  end

  defp execute_program([@inc_ptr | tail], state) do
    execute_program tail, %{state | registry: Registry.increment_pointer(state.registry)}
  end

  defp execute_program([@dec_ptr | tail], state) do
    execute_program tail, %{state | registry: Registry.decrement_pointer(state.registry)}
  end

  defp execute_program([@inc_val | tail], state) do
    execute_program tail, %{state | registry: Registry.increment_value(state.registry)}
  end

  defp execute_program([@dec_val | tail], state) do
    execute_program tail, %{state | registry: Registry.decrement_value(state.registry)}
  end

  defp execute_program([@input | tail], state) do
    case IO.read(state.io) do
      {nil, _io} ->
        {:exit_failure, :no_input}
      {input, io} ->
        execute_program tail, %{io: io, registry: Registry.put(state.registry, input)}
    end
  end

  defp execute_program([@output | tail], state) do
    execute_program tail, %{state | io: IO.write(state.io, Registry.get(state.registry))}
  end

  defp execute_program([@loop_start | _] = instructions, state) do
    case extract_loop(instructions) do
      {:ok, loop_body, rest} ->
        {:ok, state} = start_loop(loop_body, state)
        execute_program(rest, state)
      failure ->
        failure
    end
  end

  defp execute_program([@loop_end | _tail], _state) do
    {:exit_failure, :unexpected_loop_end}
  end

  defp execute_program(instructions, state) when length(instructions) == 0 do
    {:ok, state}
  end

  defp execute_program(_, _state) do
    {:exit_failure, :unknown_token}
  end

  defp start_loop(loop_body, state) do
    if Registry.get(state.registry) == 0 do
      {:ok, state}
    else
      execute_loop(loop_body, state)
    end
  end

  defp execute_loop(loop_body, state) do
    case execute_program(loop_body, state) do
      {:ok, state} ->
        start_loop(loop_body, state)
      failure ->
        failure
    end
  end
end