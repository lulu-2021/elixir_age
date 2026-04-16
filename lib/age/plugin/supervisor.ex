defmodule ElixirAge.Plugin.Supervisor do
  @moduledoc """
  Supervisor for managing age plugin processes.

  Handles spawning and managing plugin binaries that are run as separate processes.
  """

  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      # Plugins will be dynamically added
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  @doc """
  Start a plugin process.
  """
  def start_plugin(_name, _opts \\ []) do
    # TODO: Implement plugin process spawning
    {:ok, :not_implemented}
  end

  @doc """
  Stop a plugin process.
  """
  def stop_plugin(_name) do
    # TODO: Implement plugin process stopping
    :ok
  end
end
