defmodule ElixirAge.Encryption.Chacha20Test do
  use ExUnit.Case

  alias ElixirAge.Encryption.ChaCha20

  describe "symmetric encryption" do
    setup do
      key = :crypto.strong_rand_bytes(32)
      plaintext = "Hello, World!"
      {:ok, key: key, plaintext: plaintext}
    end

    test "encrypts and decrypts successfully", %{key: key, plaintext: plaintext} do
      {:ok, ciphertext} = ChaCha20.encrypt(plaintext, key)

      assert is_binary(ciphertext)
      assert ciphertext != plaintext

      {:ok, decrypted} = ChaCha20.decrypt(ciphertext, key)
      assert decrypted == plaintext
    end

    test "produces different ciphertexts for same plaintext", %{key: key, plaintext: plaintext} do
      {:ok, cipher1} = ChaCha20.encrypt(plaintext, key)
      {:ok, cipher2} = ChaCha20.encrypt(plaintext, key)

      # Should be different due to random nonces
      assert cipher1 != cipher2

      # But both decrypt to same plaintext
      {:ok, plain1} = ChaCha20.decrypt(cipher1, key)
      {:ok, plain2} = ChaCha20.decrypt(cipher2, key)

      assert plain1 == plaintext
      assert plain2 == plaintext
    end

    test "fails with wrong key", %{key: key, plaintext: plaintext} do
      {:ok, ciphertext} = ChaCha20.encrypt(plaintext, key)

      wrong_key = :crypto.strong_rand_bytes(32)
      assert {:error, _} = ChaCha20.decrypt(ciphertext, wrong_key)
    end
  end
end
