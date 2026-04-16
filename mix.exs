defmodule ElixirAge.MixProject do
  use Mix.Project

  def project do
    [
      app: :age,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: [main_module: Rage.CLI],
      name: "elixir_age",
      description: "Elixir implementation of the age file encryption format",
      source_url: "https://github.com/lulu-2021/elixir-age",
      docs: [
        main: "Age",
        extras: ["README.md"]
      ]
    ]
  end

  def application do
    [
      extra_applications: [:crypto, :logger]
    ]
  end

  defp deps do
    [
      # Cryptography - built-in crypto module from OTP covers most needs
      # May need additional packages for specific algorithms

      # Encoding
      {:bech32, "~> 1.0"},

      # Development/Testing
      {:ex_doc, "~> 0.30", only: :dev},
      {:dialyxir, "~> 1.4", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: :dev, runtime: false}
    ]
  end
end
