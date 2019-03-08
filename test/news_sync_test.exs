defmodule NewsSyncTest do
  use ExUnit.Case
  doctest NewsSync

  test "greets the world" do
    assert NewsSync.hello() == :world
  end
end
