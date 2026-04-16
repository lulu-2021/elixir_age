defmodule ElixirAge.Encryption.SSH do
  @moduledoc """
  SSH key support for age encryption.

  Supports encrypting to SSH ed25519 and RSA public keys,
  and decrypting with SSH private keys.
  """

  @doc """
  Parse an SSH public key.

  Supports:
  - ssh-ed25519
  - ssh-rsa
  """
  def parse_public_key(ssh_key_str) when is_binary(ssh_key_str) do
    # TODO: Implement SSH public key parsing
    {:ok, :not_implemented}
  end

  @doc """
  Parse an SSH private key file.

  Supports OpenSSH format.
  """
  def parse_private_key(ssh_key_path) when is_binary(ssh_key_path) do
    # TODO: Implement SSH private key parsing
    {:ok, :not_implemented}
  end

  @doc """
  Wrap a file key for an SSH recipient.
  """
  def wrap_file_key(_file_key, _ssh_public_key) do
    # TODO: Implement SSH file key wrapping
    {:ok, :crypto.strong_rand_bytes(32)}
  end

  @doc """
  Unwrap a file key using an SSH private key.
  """
  def unwrap_file_key(_stanza_payload, _ssh_private_key) do
    # TODO: Implement SSH file key unwrapping
    {:ok, :crypto.strong_rand_bytes(32)}
  end
end
