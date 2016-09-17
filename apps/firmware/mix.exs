defmodule Firmware.Mixfile do
  use Mix.Project

  @target System.get_env("NERVES_TARGET") || "rpi2"

  def project do
    [app: :firmware,
     version: "0.0.1",
     target: @target,
     archives: [nerves_bootstrap: "~> 0.1.4"],
     deps_path: "deps/#{@target}",
     build_path: "_build/#{@target}",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps ++ system(@target)]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Firmware, []},
     applications: [:logger, :nerves_networking, :nerves_cell, :unipi, :user_interface, :elixir_ale]]
  end

  def deps do
    [
      {:nerves, "~> 0.3.0"},
      {:nerves_networking, "~> 0.6"},
      {:nerves_cell, github: "ghitchens/nerves_cell"},
      {:unipi, in_umbrella: true },
      {:user_interface, in_umbrella: true},
      {:elixir_ale, "~> 0.5.6"}
    ]
  end

  def system(target) do
    [{:"nerves_system_#{target}", ">= 0.0.0"}]
  end

  def aliases do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
  end

end
