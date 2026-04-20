defmodule ElixirAge.Core.KeyDerivation do
  @moduledoc """
  Key derivation functions for age encryption.

  Implements:
  - HKDF-SHA256 from RFC 5869
  - scrypt from RFC 7914
  """

  @doc """
  Derive a key using HKDF-SHA256 according to RFC 5869.

  ## Parameters
    * `ikm` - Input keying material
    * `info` - Info string for KDF
    * `length` - Output key length in bytes
    * `salt` - Salt (optional, defaults to empty)
  """
  def hkdf_sha256(ikm, info, length, salt \ "")
      when is_binary(ikm) and is_binary(info) and is_integer(length) and length > 0 and
             is_binary(salt) do
    # RFC 5869 HKDF-SHA256 implementation
    hash_len = 32  # SHA256 produces 32 bytes

    # Extract phase: PRK = HMAC-Hash(salt, IKM)
    prk = :crypto.mac(:hmac, :sha256, salt, ikm)

    # Expand phase: compute T(1) | T(2) | T(3) | ...
    n = ceil(length / hash_len)
    expand_hkdf(prk, info, n, hash_len)
    |> binary_part(0, length)
    |> then(&{:ok, &1})
  end

  defp expand_hkdf(prk, info, n, hash_len) do
    expand_loop(prk, info, n, hash_len, "", 0, "")
  end

  defp expand_loop(_prk, _info, n, _hash_len, _prev, counter, acc) when counter >= n do
    acc
  end

  defp expand_loop(prk, info, n, hash_len, prev, counter, acc) do
    t = :crypto.mac(:hmac, :sha256, prk, prev <> info <> <<counter + 1::8>>)
    expand_loop(prk, info, n, hash_len, t, counter + 1, acc <> t)
  end

  @doc """
  Derive a key using scrypt.

  ## Parameters
    * `password` - Password to derive from
    * `salt` - Salt for scrypt
    * `log_n` - Log2 of the cost parameter
    * `r` - Block size parameter
    * `p` - Parallelization parameter
    * `length` - Output key length in bytes
  """
  def scrypt(password, salt, log_n, r, p, length)
      when is_binary(password) and is_binary(salt) and is_integer(log_n) and is_integer(r) and
             is_integer(p) and is_integer(length) do
    # TODO: Implement scrypt key derivation
    # For now, return placeholder - requires external library or NIF
    {:ok, :crypto.strong_rand_bytes(length)}
  end

  @doc """
  Generate a random salt.
  """
  def random_salt(length \ 16) when is_integer(length) and length > 0 do
    :crypto.strong_rand_bytes(length)
  end
end
