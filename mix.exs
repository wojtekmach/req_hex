defmodule ReqHex.MixProject do
  use Mix.Project

  @version "0.1.1"
  @source_url "https://github.com/wojtekmach/req_hex"

  def project do
    [
      app: :req_hex,
      version: "0.1.1",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      preferred_cli_env: [
        docs: :docs,
        "hex.publish": :docs
      ],
      docs: [
        source_url: @source_url,
        source_ref: "v#{@version}",
        main: "readme",
        extras: ["README.md", "CHANGELOG.md"]
      ],
      package: [
        description: "Req plugin for Hex API.",
        licenses: ["Apache-2.0"],
        links: %{
          "GitHub" => @source_url
        }
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:req, "~> 0.4.0"},
      {:hex_core, "~> 0.8.0"},
      {:ex_doc, ">= 0.0.0", only: :docs}
    ]
  end
end
