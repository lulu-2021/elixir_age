defmodule ElixirAgeTest do
  use ExUnit.Case
  # doctest Age

  test "version is correct" do
    # TODO: Add version check
    assert true
  end

  test "can generate keypair" do
    {:ok, {pub, sec}} = ElixirAge.generate_keypair()
    assert is_binary(pub)
    assert is_binary(sec)
    assert byte_size(pub) == 32
    assert byte_size(sec) == 32
  end
end
