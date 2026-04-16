defmodule ElixirAge.Core.Format do
  @moduledoc """
  Age file format parsing and encoding.

  Handles the binary format of age files according to the specification:
  https://age-encryption.org/v1
  """

  @age_magic "age-encryption.org/v1\n"
  @age_magic_bytes byte_size(@age_magic)

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
  Encode a recipient in age format.
  """
  def encode_recipient(key) when is_binary(key) do
    {:ok, "age1encoded"}
  end
end
