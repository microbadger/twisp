defmodule Twisp.Mixfile do
  use Mix.Project

  def project do
    [app: :twisp,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger, :cowboy, :plug, :postgrex, :extwitter],
     mod: {Twisp, []}]
  end

  defp deps do
    [{:cowboy, "~> 1.0.0"},
     {:plug, "~> 1.0"},
     {:postgrex, "~> 0.11"},
     {:extwitter, "~> 0.7"},
     {:oauth, github: "tim/erlang-oauth"}]
  end
end
