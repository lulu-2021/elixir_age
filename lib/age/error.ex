defmodule ElixirAge.Error do
  @moduledoc "Error types for the age encryption library"

  defexception [:message, :type]

  @type t :: %__MODULE__{message: String.t(), type: atom()}

  def new(message, type \\ :encryption_error) do
    %__MODULE__{message: message, type: type}
  end
end
