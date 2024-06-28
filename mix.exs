defmodule ReqHex.MixProject do
  use Mix.Project

  @version "0.2.1"
  @source_url "https://github.com/wojtekmach/req_hex"

  def project do
    [
      app: :req_hex,
      version: @version,
      elixir: "~> 1.13",
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
      {:req, "~> 0.4.0 or ~> 0.5.0"},
      {:hex_core, "~> 0.10.0"},
      {:ex_doc, ">= 0.0.0", only: :docs}
    ]
  end
end
