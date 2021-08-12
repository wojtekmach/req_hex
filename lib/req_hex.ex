defmodule ReqHex do
  def run(request, _opts) when request.uri.scheme == "hex" do
    case request.uri.host do
      "hexpm" ->
        uri = %{
          request.uri
          | scheme: "https",
            host: "repo.hex.pm",
            port: 443,
            authority: "repo.hex.pm"
        }

        request = %{request | uri: uri}

        case request.uri.path do
          "/names" ->
            request
            |> Req.append_response_steps([&ReqHex.decode_names/2])

          "/versions" ->
            request
            |> Req.append_response_steps([&ReqHex.decode_versions/2])

          "/packages/" <> name ->
            request
            |> Req.append_response_steps([&ReqHex.decode_package(&1, &2, name)])

          _ ->
            request
        end

      repo ->
        raise "repo #{inspect(repo)} is not yet supported"
    end
  end

  def run(request, _opts) do
    request
  end

  @doc false
  def decode_names(request, response) do
    response =
      update_in(response.body, fn body ->
        public_key = :hex_core.default_config().repo_public_key
        {:ok, names} = :hex_registry.unpack_names(body, "hexpm", public_key)
        names
      end)

    {request, response}
  end

  @doc false
  def decode_versions(request, response) do
    response =
      update_in(response.body, fn body ->
        public_key = :hex_core.default_config().repo_public_key
        {:ok, versions} = :hex_registry.unpack_versions(body, "hexpm", public_key)
        versions
      end)

    {request, response}
  end

  @doc false
  def decode_package(request, response, package_name) do
    response =
      update_in(response.body, fn body ->
        public_key = :hex_core.default_config().repo_public_key
        {:ok, versions} = :hex_registry.unpack_package(body, "hexpm", package_name, public_key)
        versions
      end)

    {request, response}
  end
end
