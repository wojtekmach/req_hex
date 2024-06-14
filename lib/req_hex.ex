defmodule ReqHex do
  @moduledoc """
  Req plugin for [Hex](https://hex.pm).

  ReqHex automatically decodes Hex registry resources and tarballs on these endpoints:

  ```text
  https://repo.hex.pm/names
  https://repo.hex.pm/versions
  https://repo.hex.pm/packages/<package>
  https://repo.hex.pm/tarballs/<package>-<version>.tar
  ```
  """

  @doc """
  Runs the plugin.

  ## Examples

      iex> req = Req.new(base_url: "https://repo.hex.pm") |> ReqHex.attach()
      iex> Req.get!(req, url: "/versions").body |> Enum.find(& &1.name == "req")
      %{
        name: "req",
        retired: [],
        versions: ["0.1.0", "0.1.1", "0.1.2", "0.2.0", "0.2.1", "0.2.2", ...]
      }
      iex> tarball = Req.get!(req, url: "/tarballs/req-0.1.0.tar").body
      iex> tarball["metadata.config"]["links"]
      %{"GitHub" => "https://github.com/wojtekmach/req"}
  """
  def attach(request) do
    Req.Request.append_request_steps(request, req_hex_detect: &detect/1)
  end

  defp detect(%{url: %{scheme: "https", host: "repo.hex.pm", port: 443}} = request) do
    Req.Request.prepend_response_steps(request, req_hex_decode: &decode/1)
  end

  defp detect(request) do
    request
  end

  defp decode({request, %{status: 200} = response}) do
    case request.url.path do
      "/names" ->
        {request, update_in(response.body, &decode_names/1)}

      "/versions" ->
        {request, update_in(response.body, &decode_versions/1)}

      "/packages/" <> name ->
        {request, update_in(response.body, &decode_package(&1, name))}

      "/tarballs/" <> _ ->
        {request, update_in(response.body, &decode_tarball(&1, response))}

      _ ->
        {request, response}
    end
  end

  defp decode({request, response}) do
    {request, response}
  end

  defp decode_names(body) do
    public_key = :hex_core.default_config().repo_public_key
    {:ok, names} = :hex_registry.unpack_names(body, "hexpm", public_key)
    names
  end

  defp decode_versions(body) do
    public_key = :hex_core.default_config().repo_public_key
    {:ok, versions} = :hex_registry.unpack_versions(body, "hexpm", public_key)
    versions
  end

  defp decode_package(body, package_name) do
    public_key = :hex_core.default_config().repo_public_key
    {:ok, versions} = :hex_registry.unpack_package(body, "hexpm", package_name, public_key)
    versions
  end

  defp decode_tarball(body, response) do
    ["application/octet-stream"] = Req.Response.get_header(response, "content-type")
    {:ok, files} = :erl_tar.extract({:binary, body}, [:memory])

    Map.new(files, fn
      {~c"metadata.config", value} ->
        {"metadata.config", parse_metadata(value)}

      {~c"contents.tar.gz", value} ->
        {"contents.tar.gz", parse_contents(value)}

      {name, value} ->
        {List.to_string(name), value}
    end)
  end

  defp parse_metadata(value) do
    # poor man's :file.consult/1
    {:ok, pid} = StringIO.open(value)
    parse_metadata(pid, %{})
  end

  defp parse_metadata(pid, acc) do
    case :io.parse_erl_exprs(pid, "") do
      {:ok, tokens, _location} ->
        {:value, {name, value}, _} = :erl_eval.exprs(tokens, [])
        value = if name == "links", do: Map.new(value), else: value
        parse_metadata(pid, Map.put(acc, name, value))

      {:eof, _location} ->
        acc
    end
  end

  defp parse_contents(value) do
    {:ok, files} = :erl_tar.extract({:binary, value}, [:memory, :compressed])
    Map.new(files, fn {name, value} -> {List.to_string(name), value} end)
  end
end
