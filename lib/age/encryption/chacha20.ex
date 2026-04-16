defmodule ElixirAge.Encryption.Chacha20 do
  @moduledoc """
  ChaCha20-Poly1305 symmetric encryption.

  Implements authenticated encryption according to RFC 7539.
  """

  @doc """
  Encrypt plaintext with ChaCha20-Poly1305.

  ## Parameters
    * `plaintext` - Data to encrypt
    * `key` - 32-byte encryption key
    * `aad` - Additional authenticated data (optional)

  Returns `{:ok, ciphertext}` or `{:error, reason}`.
  """
  def encrypt(plaintext, key, aad \ "") when is_binary(plaintext) and byte_size(key) == 32 do
    nonce = :crypto.strong_rand_bytes(12)

    case :crypto.crypto_one_time_aead(:chacha20_poly1305, key, nonce, plaintext, aad, true) do
      ciphertext when is_binary(ciphertext) ->
        {:ok, nonce <> ciphertext}
      error ->
        {:error, error}
    end
  end

  @doc """
  Decrypt ciphertext with ChaCha20-Poly1305.

  ## Parameters
    * `ciphertext` - Data to decrypt (includes nonce + ciphertext + tag)
    * `key` - 32-byte decryption key
    * `aad` - Additional authenticated data (optional)

  Returns `{:ok, plaintext}` or `{:error, reason}`.
  """
  def decrypt(ciphertext, key, aad \ "") when is_binary(ciphertext) and byte_size(key) == 32 do
    nonce_size = 12

    case ciphertext do
      <<nonce::binary-size(nonce_size), cipher_and_tag::binary>> ->
        case :crypto.crypto_one_time_aead(:chacha20_poly1305, key, nonce, cipher_and_tag, aad, false) do
          plaintext when is_binary(plaintext) ->
            {:ok, plaintext}
          error ->
            {:error, error}
        end
      _ ->
        {:error, "invalid_ciphertext_size"}
    end
  end
end
