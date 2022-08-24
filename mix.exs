defmodule ReqHex.MixProject do
  use Mix.Project

  def project do
    [
      app: :req_hex,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      preferred_cli_env: [
        docs: :docs,
        "hex.publish": :docs
      ],
      docs: [
        main: "readme",
        extras: ["README.md", "CHANGELOG.md"]
      ],
      package: [
        description: "Req plugin for Hex API.",
        licenses: ["Apache-2.0"],
        links: %{
          "GitHub" => "https://github.com/wojtekmach/req_hex"
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
      {:req, "~> 0.3.0"},
      {:hex_core, "~> 0.8.0"},
      {:ex_doc, ">= 0.0.0", only: :docs}
    ]
  end
end
