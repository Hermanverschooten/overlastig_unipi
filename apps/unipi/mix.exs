defmodule Unipi.Mixfile do
  use Mix.Project

  def project do
    [app: :unipi,
     version: "0.1.0",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: applications(Mix.env)]
  end
  def applications(:prod) do
    [ :elixir_ale | applications(:all) ]
  end

  def applications(_) do
    [:logger]
  end

  defp deps do
    [
      {:dummy_libs, in_umbrella: true, only: [:dev, :test]},
      {:gpio_rpi, "~> 0.1.0"},
      {:elixir_ale, "~> 0.5.6", only: :prod}
    ]
  end
end
