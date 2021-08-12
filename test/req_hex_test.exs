defmodule ReqHexTest do
  use ExUnit.Case
  doctest ReqHex

  test "names" do
    names = Req.get!("hex://hexpm/names", plugins: [ReqHex]).body
    assert Enum.find(names, &(&1.name == "decimal"))
  end

  test "versions" do
    versions = Req.get!("hex://hexpm/versions", plugins: [ReqHex]).body
    assert Enum.find(versions, &(&1.name == "decimal"))
  end

  test "package" do
    releases = Req.get!("hex://hexpm/packages/decimal", plugins: [ReqHex]).body
    assert Enum.find(releases, &(&1.version == "2.0.0"))
  end

  test "tarball" do
    tarball = Req.get!("hex://hexpm/tarballs/decimal-2.0.0.tar", plugins: [ReqHex]).body
    assert List.keyfind(tarball, 'metadata.config', 0)
  end
end
