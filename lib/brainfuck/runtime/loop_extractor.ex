defmodule Brainfuck.Runtime.LoopExtractor do
  import Brainfuck.Helper.List

  @loop_start ?[
  @loop_end ?]

  @type loop_extraction_result :: {:ok, loop_body :: charlist, rest :: charlist} | {:exit_failure, :open_loop}

  @spec extract_loop(instructions :: charlist) :: loop_extraction_result

  @doc """
  Extract the top-most loop in the given instructions.
  The argument must start with the "loop start" character: `?[`

  ## Examples

      iex> Brainfuck.Runtime.LoopExtractor.extract_loop('[>++<-].,<.')
      {:ok, '>++<-', '.,<.'}

      iex> Brainfuck.Runtime.LoopExtractor.extract_loop('[>++')
      {:exit_failure, :open_loop}
      
  """
  def extract_loop([@loop_start | rest]) do
    extract_loop(rest, 1, [])
  end

  defp extract_loop([@loop_start | rest], depth, loop_body) do
    extract_loop(rest, depth + 1, append(loop_body, @loop_start))
  end

  defp extract_loop([@loop_end | rest], 1, loop_body) do
    {:ok, loop_body, rest}
  end

  defp extract_loop([@loop_end | rest], depth, loop_body) do
    extract_loop(rest, depth - 1, append(loop_body, @loop_end))
  end

  defp extract_loop([instruction | rest], depth, loop_body) do
    extract_loop(rest, depth, append(loop_body, instruction))
  end

  defp extract_loop(_, _depth, _loop_body) do
    {:exit_failure, :open_loop}
  end
end