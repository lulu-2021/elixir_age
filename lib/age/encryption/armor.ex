defmodule ElixirAge.Encryption.Armor do
  @moduledoc """
  PEM armor encoding and decoding for age files.

  Wraps binary age files in standard PEM format with "AGE ENCRYPTED FILE" headers.
  """

  @pem_begin "-----BEGIN AGE ENCRYPTED FILE-----"
  @pem_end "-----END AGE ENCRYPTED FILE-----"

  @doc """
  Encode binary age file to PEM armor format.

  Returns `{:ok, armored_string}` or `{:error, reason}`.
  """
  def encode(binary) when is_binary(binary) do
    try do
      b64 = Base.encode64(binary)

      wrapped =
        b64
        |> String.to_charlist()
        |> Enum.chunk_every(64)
        |> Enum.map(&List.to_string/1)
        |> Enum.join("\n")

      armored = "#{@pem_begin}\n#{wrapped}\n#{@pem_end}\n"
      {:ok, armored}
    rescue
      e ->
        {:error, "armor_encoding_failed: #{inspect(e)}"}
    end
  end

  @doc """
  Decode PEM armor format to binary age file.

  Returns `{:ok, binary}` or `{:error, reason}`.
  """
  def decode(pem_str) when is_binary(pem_str) do
    try do
      lines = String.split(pem_str, "\n")

      case lines do
        [@pem_begin | rest] ->
          # Remove the end marker line and empty lines
          rest =
            rest
            |> Enum.reject(&(&1 == @pem_end))
            |> Enum.reject(&(&1 == ""))

          b64 = Enum.join(rest, "")

          case Base.decode64(b64) do
            {:ok, binary} -> {:ok, binary}
            :error -> {:error, "invalid_base64_in_armor"}
          end

        _ ->
          {:error, "invalid_pem_format"}
      end
    rescue
      e ->
        {:error, "armor_decoding_failed: #{inspect(e)}"}
    end
  end
end
