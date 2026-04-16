defmodule ElixirAge.Identity.Passphrase do
  @moduledoc """
  Passphrase-based encryption and decryption.

  Implements passphrase wrapping using scrypt and ChaCha20-Poly1305.
  """

  alias ElixirAge.Core.KeyDerivation
  alias ElixirAge.Encryption.Chacha20

  # Passphrase parameters from age spec
  @default_log_n 18
  @default_r 3
  @default_p 1

  @doc """
  Wrap a file key with a passphrase.

  Returns a stanza that can be used to encrypt the file key.
  """
  def wrap(file_key, passphrase, opts \\ []) do
    log_n = Keyword.get(opts, :log_n, @default_log_n)
    r = Keyword.get(opts, :r, @default_r)
    p = Keyword.get(opts, :p, @default_p)
    salt = Keyword.get(opts, :salt, KeyDerivation.random_salt(16))

    # TODO: Implement passphrase wrapping
    {:ok, %{}}
  end

  @doc """
  Unwrap a file key from a passphrase stanza.
  """
  def unwrap(stanza, passphrase, opts \\ []) do
    # TODO: Implement passphrase unwrapping
    {:ok, :crypto.strong_rand_bytes(32)}
  end

  @doc """
  Generate a secure random passphrase.

  Returns a list of random words.
  """
  def generate_passphrase do
    # TODO: Implement passphrase generation from wordlist
    ["example", "passphrase", "words"]
  end
end
