defmodule AppTwoTest do
  use ExUnit.Case
  doctest AppTwo

  test "greets the world" do
    assert AppTwo.hello_unit() == :unit_world
  end
end
