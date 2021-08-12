defmodule ReqHex.MixProject do
  use Mix.Project

  def project do
    [
      app: :req_hex,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:req, "~> 0.1.0", github: "wojtekmach/req", branch: "wm-plugins"},
      {:hex_core, ">= 0.0.0"}
    ]
  end
end
