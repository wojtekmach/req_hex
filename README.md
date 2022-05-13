# ReqHex

[Req](https://github.com/wojtekmach/req_s3) plugin for [Hex](https://hex.pm).

ReqHex automatically decodes Hex registry resources and tarballs on these endpoints:

```text
https://repo.hex.pm/names
https://repo.hex.pm/versions
https://repo.hex.pm/packages/<package>
https://repo.hex.pm/tarballs/<package>-<version>.tar
```

## Usage

```elixir
Mix.install([
  {:req, github: "wojtekmach/req"},
  {:req_hex, github: "wojtekmach/req_hex"}
])

req = Req.new(base_url: "https://repo.hex.pm") |> ReqHex.attach()

Req.get!(req, url: "/versions").body |> Enum.find(& &1.name == "req")
#=>
# %{
#   name: "req",
#   retired: [],
#   versions: ["0.1.0", "0.1.1", "0.1.2", "0.2.0", "0.2.1", "0.2.2", ...]
# }

tarball = Req.get!(req, url: "/tarballs/req-0.1.0.tar").body

tarball["metadata.config"]["links"]
#=> %{"GitHub" => "https://github.com/wojtekmach/req"}

IO.puts body["contents.tar.gz"]["mix.exs"]
# Outputs:
# defmodule Req.MixProject do
#   use Mix.Project
#
#   @version "0.1.0"
#   @source_url "https://github.com/wojtekmach/req"
#
#   def project do
#     [
#       app: :req,
#       version: "0.1.0",
#       elixir: "~> 1.11",
#       start_permanent: Mix.env() == :prod,
#       deps: deps(),
#       package: package(),
#       docs: docs(),
#       xref: [
#         exclude: [
#           NimbleCSV.RFC4180
#         ]
#       ]
#     ]
#   end
#   ...
:ok
```
