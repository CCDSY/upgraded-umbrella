defmodule Runtime.RegistryTest do
  use ExUnit.Case, async: true
  alias Brainfuck.Runtime.Registry

  setup do
    {:ok, registry: %Registry{}}
  end

  test "put value at default position", %{registry: registry} do
    assert Registry.get(registry) == 0

    assert registry
    |> Registry.put(10)
    |> Registry.get == 10
  end

  test "get value after incrementing pointer", %{registry: registry} do
    assert registry
    |> Registry.increment_pointer
    |> Registry.get == 0
  end

  test "get value after decrementing pointer", %{registry: registry} do
    assert registry
    |> Registry.decrement_pointer
    |> Registry.get == 0
  end

  test "put value after incrementing pointer", %{registry: registry} do
    registry = registry
    |> Registry.increment_pointer
    |> Registry.increment_pointer
    |> Registry.put(10)
    assert Registry.get(registry) == 10
    registry = Registry.decrement_pointer(registry)
    assert Registry.get(registry) == 0
    assert registry
    |> Registry.decrement_pointer
    |> Registry.get == 0
  end

  test "put value after decrementing pointer", %{registry: registry} do
    registry = registry
    |> Registry.decrement_pointer
    |> Registry.decrement_pointer
    |> Registry.put(10)
    assert Registry.get(registry) == 10
    registry = Registry.increment_pointer(registry)
    assert Registry.get(registry) == 0
    assert registry
    |> Registry.increment_pointer
    |> Registry.get == 0
  end

  test "increment value at default position", %{registry: registry} do
    assert Registry.get(registry) == 0
    assert registry
    |> Registry.increment_value
    |> Registry.get == 1
  end

  test "decrement value at default position", %{registry: registry} do
    assert Registry.get(registry) == 0
    assert registry
    |> Registry.decrement_value
    |> Registry.get == -1
  end

  test "increment value after decrementing pointer", %{registry: registry} do
    registry = registry
    |> Registry.decrement_pointer
    |> Registry.decrement_pointer
    |> Registry.increment_value
    assert Registry.get(registry) == 1
    registry = Registry.increment_pointer(registry)
    assert Registry.get(registry) == 0
    registry = Registry.increment_pointer(registry)
    assert Registry.get(registry) == 0
  end

  test "decrement value after incrementing pointer", %{registry: registry} do
    registry = registry
    |> Registry.increment_pointer
    |> Registry.increment_pointer
    |> Registry.decrement_value
    assert Registry.get(registry) == -1
    registry = Registry.decrement_pointer(registry)
    assert Registry.get(registry) == 0
    registry = Registry.decrement_pointer(registry)
    assert Registry.get(registry) == 0
  end
end
