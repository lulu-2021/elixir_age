defmodule ElixirAge.Encryption.ChaCha20 do
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
  def encrypt(plaintext, key, aad \\ "") when is_binary(plaintext) and byte_size(key) == 32 do
    nonce = :crypto.strong_rand_bytes(12)

    try do
      {ciphertext, tag} =
        :crypto.crypto_one_time_aead(:chacha20_poly1305, key, nonce, plaintext, aad, true)

      {:ok, nonce <> ciphertext <> tag}
    rescue
      e ->
        {:error, "encryption_failed: #{inspect(e)}"}
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
  def decrypt(ciphertext, key, aad \\ "") when is_binary(ciphertext) and byte_size(key) == 32 do
    nonce_size = 12
    tag_size = 16

    case ciphertext do
      <<nonce::binary-size(nonce_size), rest::binary>> ->
        cipher_len = byte_size(rest) - tag_size

        case rest do
          <<cipher::binary-size(cipher_len), tag::binary-size(tag_size)>> ->
            try do
              plaintext =
                :crypto.crypto_one_time_aead(
                  :chacha20_poly1305,
                  key,
                  nonce,
                  # ✅ Separate ciphertext
                  cipher,
                  aad,
                  false,
                  # ✅ Pass tag for verification
                  tag
                )

              {:ok, plaintext}
            rescue
              e ->
                {:error, "decryption_failed: #{inspect(e)}"}
            end

          _ ->
            {:error, "invalid_ciphertext_size"}
        end

      _ ->
        {:error, "invalid_ciphertext_size"}
    end
  end
end
