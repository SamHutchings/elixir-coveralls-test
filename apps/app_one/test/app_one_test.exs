defmodule AppOneTest do
  use ExUnit.Case
  doctest AppOne

  test "greets the world" do
    assert AppOne.hello() == :world
  end

  test "greets the unit world" do
    assert AppOne.hello_unit() == :unit_world
  end
end
