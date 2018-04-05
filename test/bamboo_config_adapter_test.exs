defmodule BambooConfigAdapterTest do
  use ExUnit.Case
  doctest BambooConfigAdapter

  test "greets the world" do
    assert BambooConfigAdapter.hello() == :world
  end
end
