# CHANGELOG

## v0.2.1 (2024-06-14)

  * Handle `/docs` endpoint.

  * Handle `decode_body: false` and `raw: true` options.

## v0.2.0 (2024-06-14)

  * Update to `hex_core` v0.10.

    hex_core v0.9 changed API and so this is a breaking change too.

    Before:

    ```elixir
    iex> Req.get!(Req.new() |> ReqHex.attach(), url: "https://repo.hex.pm/packages/req").body |> hd()
    %{
      version: "0.1.0",
      dependencies: [
        %{package: "finch", requirement: "~> 0.6.0"},
        %{package: "jason", requirement: "~> 1.0"},
        %{package: "mime", requirement: "~> 1.6"},
        %{package: "nimble_csv", optional: true, requirement: "~> 1.0"}
      ],
      inner_checksum: <<212, 242, 173, 204, 130, 43, 36, 38, 69, 135, 31, 227, 182,
        89, 141, 185, 39, 159, 250, 87, 208, 159, 52, 185, 74, 51, 129, 154, 105,
        178, 134, 12>>,
      outer_checksum: <<160, 96, 167, 181, 93, 87, 43, 162, 70, 61, 210, 2, 248, 81,
        190, 238, 232, 115, 158, 9, 141, 162, 166, 214, 110, 184, 92, 174, 203, 214,
        201, 18>>
    }
    ```

    After:

    ```elixir
    iex> Req.get!(Req.new() |> ReqHex.attach(), url: "https://repo.hex.pm/packages/req").body |> Map.keys()
    [:name, :repository, :releases]

    iex> Req.get!(Req.new() |> ReqHex.attach(), url: "https://repo.hex.pm/packages/req").body.releases |> hd()
    %{
      version: "0.1.0",
      dependencies: [
        %{package: "finch", requirement: "~> 0.6.0"},
        %{package: "jason", requirement: "~> 1.0"},
        %{package: "mime", requirement: "~> 1.6"},
        %{package: "nimble_csv", optional: true, requirement: "~> 1.0"}
      ],
      inner_checksum: <<212, 242, 173, 204, 130, 43, 36, 38, 69, 135, 31, 227, 182,
        89, 141, 185, 39, 159, 250, 87, 208, 159, 52, 185, 74, 51, 129, 154, 105,
        178, 134, 12>>,
      outer_checksum: <<160, 96, 167, 181, 93, 87, 43, 162, 70, 61, 210, 2, 248, 81,
        190, 238, 232, 115, 158, 9, 141, 162, 166, 214, 110, 184, 92, 174, 203, 214,
        201, 18>>
    }
    ```

  * Fix handling non-200 responses

## v0.1.1 (2023-09-01)

  * Support Req v0.4.

## v0.1.0 (2022-08-24)

  * Initial release
