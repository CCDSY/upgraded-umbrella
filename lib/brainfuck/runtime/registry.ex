defmodule Brainfuck.Runtime.Registry do
  import Brainfuck.Helper.List
  
  defstruct pointer: 0, values: [0]
  
  @doc """
  Puts a value in the registry at the current position.
  """
  def put(registry, elem) do
    registry |> adjust_pointer |> update(elem)
  end
  
  @doc """
  Gets the value at the current position in the registry.
  """
  def get(%{pointer: pointer, values: list}) when pointer >= 0 and pointer < length(list) do
    Enum.at(list, pointer)
  end

  def get(_registry) do
    0
  end
  
  @doc """
  Increment the pointer of the current position.
  """
  def increment_pointer(%{pointer: pointer, values: _values} = registry) do
    %{registry | pointer: pointer + 1}
  end
  
  @doc """
  Decrement the pointer of the current position.
  """
  def decrement_pointer(%{pointer: pointer, values: _values} = registry) do
    %{registry | pointer: pointer - 1}
  end
  
  @doc """
  Increment the value at the current position.
  """
  def increment_value(registry) do
    put(registry, get(registry) + 1)
  end
  
  @doc """
  Decrement the value at the current position.
  """
  def decrement_value(registry) do
    put(registry, get(registry) - 1)
  end
  
  # Updates the value in the registry list at the registry pointer.
  defp update(%{pointer: pointer, values: list} = registry, elem) do
    %{registry | values: List.update_at(list, pointer, fn _ -> elem end)}
  end
  
  # Adjust the pointer to a position where the value can be updated. 
  defp adjust_pointer(%{pointer: pointer, values: list}) when pointer < 0 do
    adjust_pointer %{pointer: pointer + 1, values: prepend(list, 0)}
  end
  
  defp adjust_pointer(%{pointer: pointer, values: list} = registry) when pointer >= length(list) do
    adjust_pointer %{registry | values: append(list, 0)}
  end
  
  defp adjust_pointer(registry) do
    registry
  end
end