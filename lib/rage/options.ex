defmodule ElixirAge.CLI.Options do
  @moduledoc """
  CLI option handling and validation.
  """

  defstruct [
    :input,
    :output,
    :recipients,
    :identity,
    :passphrase,
    :armor,
    :decrypt,
    :encrypt,
    :max_work_factor
  ]

  @type t :: %__MODULE__{
          input: String.t() | nil,
          output: String.t() | nil,
          recipients: list(String.t()),
          identity: String.t() | nil,
          passphrase: boolean(),
          armor: boolean(),
          decrypt: boolean(),
          encrypt: boolean(),
          max_work_factor: integer()
        }

  @doc """
  Validate parsed options.
  """
  def validate(opts) when is_map(opts) do
    # TODO: Implement option validation
    {:ok, opts}
  end

  @doc """
  Set default values for options.
  """
  def defaults(opts) when is_map(opts) do
    Map.merge(
      %{
        armor: false,
        decrypt: false,
        encrypt: true,
        passphrase: false,
        max_work_factor: 18,
        recipients: [],
        input: nil,
        output: nil,
        identity: nil
      },
      opts
    )
  end
end
