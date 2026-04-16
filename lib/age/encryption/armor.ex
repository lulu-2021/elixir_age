defmodule ElixirAge.Encryption.Armor do
  @moduledoc """
  PEM armor encoding and decoding for age files.

  Wraps binary age files in standard PEM format with "AGE ENCRYPTED FILE" headers.
  """

  @pem_begin "-----BEGIN AGE ENCRYPTED FILE-----"
  @pem_end "-----END AGE ENCRYPTED FILE-----"

  @doc """
  Encode binary age file to PEM armor format.
  """
  def encode(binary) when is_binary(binary) do
    b64 = Base.encode64(binary, padding: true)

    wrapped =
      b64
      |> String.to_charlist()
      |> Enum.chunk_every(64)
      |> Enum.map(&List.to_string/1)
      |> Enum.join("\n")

    "#{@pem_begin}\n#{wrapped}\n#{@pem_end}\n"
  end

  @doc """
  Decode PEM armor format to binary age file.
  """
  def decode(pem_str) when is_binary(pem_str) do
    lines = String.split(pem_str, "\n")

    case lines do
      [@pem_begin | rest] ->
        # Remove the end marker line
        rest =
          rest
          |> Enum.reject(&(&1 == @pem_end))
          |> Enum.reject(&(&1 == ""))

        b64 = Enum.join(rest, "")

        case Base.decode64(b64, padding: true) do
          {:ok, binary} -> {:ok, binary}
          :error -> {:error, "invalid_base64_in_armor"}
        end

      _ ->
        {:error, "invalid_pem_format"}
    end
  end
end
