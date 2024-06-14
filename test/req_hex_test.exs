defmodule ReqHexTest do
  use ExUnit.Case

  test "names" do
    req = Req.new(base_url: "https://repo.hex.pm") |> ReqHex.attach()
    %{repository: "hexpm", packages: names} = Req.get!(req, url: "/names").body
    assert Enum.find(names, &(&1.name == "req"))
  end

  test "versions" do
    req = Req.new(base_url: "https://repo.hex.pm") |> ReqHex.attach()
    %{repository: "hexpm", packages: versions} = Req.get!(req, url: "/versions").body
    assert Enum.find(versions, &(&1.name == "req"))
  end

  test "package" do
    req = Req.new(base_url: "https://repo.hex.pm") |> ReqHex.attach()

    %{repository: "hexpm", name: "req", releases: releases} =
      Req.get!(req, url: "/packages/req").body

    assert Enum.find(releases, &(&1.version == "0.1.0"))

    assert Req.get!(req, url: "/packages/404").status == 404
  end

  test "tarball" do
    req = Req.new(base_url: "https://repo.hex.pm") |> ReqHex.attach()
    tarball = Req.get!(req, url: "/tarballs/req-0.1.0.tar").body

    assert tarball["metadata.config"]["app"] == "req"

    assert tarball["metadata.config"]["links"] == %{
             "GitHub" => "https://github.com/wojtekmach/req"
           }

    assert "defmodule Req do\n" <> _ = tarball["contents.tar.gz"]["lib/req.ex"]
  end

  test "docs" do
    req = Req.new(base_url: "https://repo.hex.pm") |> ReqHex.attach()
    files = Req.get!(req, url: "/docs/req_hex-0.1.0.tar.gz").body
    assert "index.html" in Enum.map(files, &to_string(elem(&1, 0)))
  end
end
