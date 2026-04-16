defmodule ElixirAge.CLI do
  @moduledoc """
  Rage CLI main entry point.

  This is the command-line interface for age encryption.
  """

  @doc """
  Main entry point for the CLI.
  """
  def main(args) do
    args
    |> parse_args()
    |> execute()
    |> handle_result()
  end

  defp parse_args(args) do
    # TODO: Implement argument parsing with OptionParser
    {:ok, :command, []}
  end

  defp execute({:ok, cmd, opts}) do
    # TODO: Create ElixirAge.CLI.Command module
    {:ok, "Command executed"}
  end

  defp execute({:error, reason}) do
    {:error, reason}
  end

  defp handle_result({:ok, result}) do
    IO.puts(result)
    System.halt(0)
  end

  defp handle_result({:error, reason}) do
    # TODO: Create ElixirAge.CLI.Output module
    IO.puts(:stderr, "Error: #{reason}")
    System.halt(1)
  end
end

# Entry point for escript
defmodule ElixirAge.Main do
  def main(args) do
    ElixirAge.CLI.main(args)
  end
end
