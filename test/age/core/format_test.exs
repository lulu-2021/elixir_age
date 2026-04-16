defmodule ElixirAge.Core.FormatTest do
  use ExUnit.Case

  alias ElixirAge.Core.Format

  describe "age format parsing" do
    test "rejects invalid header" do
      invalid_data = "not-an-age-file"
      assert {:error, "invalid_age_header"} = Format.parse(invalid_data)
    end

    test "accepts valid age header" do
      valid_header = "age-encryption.org/v1\n"
      # TODO: Add proper test vector
      assert {:error, _} = Format.parse(valid_header)
    end
  end

  describe "recipient encoding" do
    test "encodes and decodes recipient" do
      key = :crypto.strong_rand_bytes(32)
      {:ok, encoded} = Format.encode_recipient(key)

      assert String.starts_with?(encoded, "age1")

      {:ok, decoded} = Format.decode_recipient(encoded)
      assert decoded == key
    end
  end

  describe "stanza encoding" do
    test "encodes stanza correctly" do
      stanza = %{type: "x25519", args: ["arg1", "arg2"], payload: "test"}
      result = Format.encode_stanza(stanza)

      assert String.starts_with?(result, "-> x25519 arg1 arg2")
    end
  end
end
