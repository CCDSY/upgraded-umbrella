defmodule Brainfuck.Helper.List do
  @doc """
  Insert a value at the start of the list.
  """
  def prepend(list, elem) do
    List.insert_at list, 0, elem
  end

  @doc """
  Insert a value at the end of the list
  """
  def append(list, elem) do
    List.insert_at list, length(list), elem
  end
end