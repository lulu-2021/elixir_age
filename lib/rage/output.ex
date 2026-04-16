defmodule ElixirAge.CLI.Output do
  @moduledoc """
  CLI output formatting and helpers.
  """

  @doc """
  Print an error message to stderr.
  """
  def error(message) when is_binary(message) do
    IO.write(:stderr, "Error: #{message}\n")
  end

  @doc """
  Print a warning message to stderr.
  """
  def warn(message) when is_binary(message) do
    IO.write(:stderr, "Warning: #{message}\n")
  end

  @doc """
  Print an info message to stdout.
  """
  def info(message) when is_binary(message) do
    IO.puts(message)
  end

  @doc """
  Print help message.
  """
  def help do
    help_text = """
    Usage: rage [--encrypt] (-r RECIPIENT | -R PATH)... [-i IDENTITY] [-a] [-o OUTPUT] [INPUT]
           rage [--encrypt] --passphrase [-a] [-o OUTPUT] [INPUT]
           rage --decrypt [-i IDENTITY] [-o OUTPUT] [INPUT]

    Arguments:
      [INPUT]  Path to a file to read from.

    Options:
      -h, --help                    Print this help message and exit.
      -V, --version                 Print version info and exit.
      -e, --encrypt                 Encrypt the input (the default).
      -d, --decrypt                 Decrypt the input.
      -p, --passphrase              Encrypt with a passphrase instead of recipients.
      --max-work-factor <WF>        Maximum work factor to allow for passphrase decryption.
      -a, --armor                   Encrypt to a PEM encoded format.
      -r, --recipient <RECIPIENT>   Encrypt to the specified RECIPIENT. May be repeated.
      -R, --recipients-file <PATH>  Encrypt to the recipients listed at PATH. May be repeated.
      -i, --identity <IDENTITY>     Use the identity file at IDENTITY. May be repeated.
      -j <PLUGIN-NAME>              Use age-plugin-PLUGIN-NAME in its default mode as an identity.
      -o, --output <OUTPUT>         Write the result to the file at path OUTPUT.
    """

    IO.puts(help_text)
  end

  @doc """
  Print version information.
  """
  def version do
    IO.puts("rage 0.1.0 (Elixir implementation)")
  end
end
