defmodule ElixirAge.Core.Format do
  @moduledoc """
  Age file format parsing and encoding.

  Handles the binary format of age files according to the specification:
  https://age-encryption.org/v1
  """

  @age_magic "age-encryption.org/v1\n"

  @doc """
  Parse an age file.

  Returns `{:ok, %{version: 1, stanzas: [...], payload: binary}}` or error.
  """
  def parse(data) when is_binary(data) do
    case data do
      <<@age_magic::binary, rest::binary>> ->
        {:ok, %{version: 1, stanzas: [], payload: rest}}

      _ ->
        {:error, "invalid_age_format"}
    end
  end

  @doc """
  Encode an age file header.
  """
  def encode_header(version, stanzas) when is_integer(version) and is_list(stanzas) do
    @age_magic
  end

  @doc """
  Encode a recipient in age format using Bech32.
  Accepts raw 32-byte key and returns Bech32-encoded "age1..." format.
  """
  def encode_recipient(key) when is_binary(key) and byte_size(key) == 32 do
    try do
      encoded = Bech32.encode("age", key)
      {:ok, encoded}
    rescue
      e ->
        {:error, "Failed to encode recipient: #{inspect(e)}"}
    end
  end

  @doc """
  Decode a recipient from age format.
  Accepts Bech32-encoded "age1..." string and returns raw 32-byte key.
  """
  def decode_recipient(encoded) when is_binary(encoded) do
    try do
      case Bech32.decode(encoded) do
        {:ok, hrp, data} when hrp == "age" ->
          if byte_size(data) == 32 do
            {:ok, data}
          else
            {:error, "Invalid recipient key length"}
          end

        {:ok, _hrp, _data} ->
          {:error, "Invalid recipient prefix"}

        :error ->
          {:error, "Invalid Bech32 encoding"}
      end
    rescue
      e ->
        {:error, "Failed to decode recipient: #{inspect(e)}"}
    end
  end

  @doc """
  Encode a stanza for the age format.
  """
  def encode_stanza(stanza) when is_map(stanza) do
    type = Map.get(stanza, :type, "")
    args = Map.get(stanza, :args, [])
    payload = Map.get(stanza, :payload, "")

    args_str = Enum.join(args, " ")
    "-> #{type} #{args_str}\n#{payload}"
  end
end
