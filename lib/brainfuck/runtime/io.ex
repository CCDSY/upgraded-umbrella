defmodule Brainfuck.Runtime.IO do
  import Brainfuck.Helper.List

  defstruct inputs: [], outputs: []

  def set_input(io, nil) do
    io
  end

  def set_input(io, input) do
    %{io | inputs: String.to_charlist(input)}
  end

  def read(%{inputs: [head | tail]} = io) do
    {head, %{io | inputs: tail}}
  end

  def read(io) do
    {nil, io}
  end

  def write(io, value) do
    %{io | outputs: append(io.outputs, value)}
  end

  def output(io) do
    to_string io.outputs
  end
end