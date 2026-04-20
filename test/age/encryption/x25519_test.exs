defmodule ElixirAge.Encryption.X25519Test do
  use ExUnit.Case

  alias ElixirAge.Encryption.X25519

  describe "keypair generation" do
    test "generates valid keypair" do
      {:ok, {pub, sec}} = X25519.generate_keypair()

      assert is_binary(pub)
      assert is_binary(sec)
      # ✅ Check format
      assert String.starts_with?(pub, "age1")
      # ✅ Check format
      assert String.starts_with?(sec, "AGE-SECRET-KEY")
      # ✅ Bech32 encoded is longer
      assert byte_size(pub) > 32
      assert byte_size(sec) > 32
    end

    test "generates different keypairs each time" do
      {:ok, {pub1, sec1}} = X25519.generate_keypair()
      {:ok, {pub2, sec2}} = X25519.generate_keypair()

      assert pub1 != pub2
      assert sec1 != sec2
    end
  end

  describe "key operations" do
    test "derives public key from secret" do
      {:ok, {expected_pub, sec}} = X25519.generate_keypair()
      {:ok, derived_pub} = X25519.public_key(sec)

      assert derived_pub == expected_pub
    end
  end
end
