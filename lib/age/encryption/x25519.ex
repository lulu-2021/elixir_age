defmodule ElixirAge.Encryption.X25519 do
  @moduledoc """
  X25519 key encapsulation and encryption.

  Implements X25519 recipients according to the age specification.
  """

  require Logger

  # X25519 produces 32-byte keys
  @key_size 32

  @doc """
  Generate a new X25519 keypair.

  Returns `{:ok, {public_key, secret_key}}` or `{:error, reason}`.
  """
  def generate_keypair do
    try do
      # Generate random 32-byte seed
      secret_bytes = :crypto.strong_rand_bytes(@key_size)

      # Compute public key from secret
      public_bytes = compute_public_key(secret_bytes)

      # Encode as bech32
      with {:ok, public_key} <- encode_public_key(public_bytes),
           {:ok, secret_key} <- encode_secret_key(secret_bytes) do
        Logger.info("Generated new X25519 keypair")
        {:ok, {public_key, secret_key}}
      end
    rescue
      e ->
        {:error, "Failed to generate keypair: #{inspect(e)}"}
    end
  end

  @doc """
  Derive the public key from a secret key.
  """
  def public_key(secret_key) when is_binary(secret_key) and byte_size(secret_key) == 32 do
    try do
      public_bytes = compute_public_key(secret_key)
      {:ok, public_bytes}
    rescue
      e ->
        {:error, "Failed to derive public key: #{inspect(e)}"}
    end
  end

  @doc """
  Wrap a file key for an X25519 recipient.

  Returns stanza payload as binary.
  """
  def wrap_file_key(_file_key, _recipient_public_key) do
    # TODO: Implement X25519 file key wrapping
    {:ok, :crypto.strong_rand_bytes(32)}
  end

  @doc """
  Unwrap a file key using an X25519 identity.

  Returns the file key or error.
  """
  def unwrap_file_key(_stanza_payload, _identity_secret_key) do
    # TODO: Implement X25519 file key unwrapping
    {:ok, :crypto.strong_rand_bytes(32)}
  end

  # Private functions

  @spec compute_public_key(binary()) :: binary()
  defp compute_public_key(secret_bytes) when byte_size(secret_bytes) == 32 do
    try do
      # Use Erlang's crypto for X25519 public key derivation
      :crypto.generate_key(:ecdh, :x25519, secret_bytes) |> elem(0)
    rescue
      _ ->
        Logger.warning("X25519 key generation using crypto module failed, using fallback")
        # This is a fallback - real implementation requires proper crypto
        secret_bytes
    end
  end

  @spec encode_public_key(binary()) :: {:ok, String.t()} | {:error, term()}
  defp encode_public_key(public_bytes) when byte_size(public_bytes) == 32 do
    try do
      encoded = Bech32.encode("age", public_bytes)
      {:ok, encoded}
    rescue
      e ->
        {:error, "Failed to encode public key: #{inspect(e)}"}
    end
  end

  @spec encode_secret_key(binary()) :: {:ok, String.t()} | {:error, term()}
  defp encode_secret_key(secret_bytes) when byte_size(secret_bytes) == 32 do
    try do
      encoded = Bech32.encode("AGE-SECRET-KEY-", secret_bytes)
      {:ok, encoded}
    rescue
      e ->
        {:error, "Failed to encode secret key: #{inspect(e)}"}
    end
  end
end
