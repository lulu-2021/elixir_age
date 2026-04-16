defmodule ElixirAge.Core.Recipient do
  @moduledoc """
  Recipient type definitions and handling.

  Recipients can be:
  - age public keys (X25519)
  - SSH public keys (ed25519, rsa)
  - Plugin recipients
  """

  defmodule X25519 do
    @moduledoc "X25519 recipient"

    defstruct [:public_key]
  end

  defmodule SSH do
    @moduledoc "SSH public key recipient"

    defstruct [:type, :key_data]
  end

  defmodule Plugin do
    @moduledoc "Plugin recipient"

    defstruct [:name, :data]
  end

  @doc """
  Parse a recipient string.

  Supports:
  - age1... (X25519)
  - ssh-ed25519 ...
  - ssh-rsa ...
  - age1name... (plugin recipients)
  """
  def parse(recipient_str) when is_binary(recipient_str) do
    cond do
      String.starts_with?(recipient_str, "age1") ->
        parse_age_recipient(recipient_str)

      String.starts_with?(recipient_str, "ssh-") ->
        parse_ssh_recipient(recipient_str)

      true ->
        {:error, "unknown_recipient_type"}
    end
  end

  defp parse_age_recipient(str) do
    # TODO: Implement age recipient parsing
    {:ok, %X25519{}}
  end

  defp parse_ssh_recipient(str) do
    # TODO: Implement SSH recipient parsing
    {:ok, %SSH{}}
  end
end
