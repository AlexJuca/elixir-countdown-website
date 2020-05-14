defmodule Okta do
    use OAuth2.Strategy

    def client do
        site = System.get_env("OKTA_DOMAIN")
        OAuth2.Client.new([
            strategy: __MODULE__,
            client_id: System.get_env("OKTA_CLIENT_ID"),
            client_secret: System.get_env("OKTA_CLIENT_SECRET"),
            site: site,
            redirect_uri: "http://127.0.0.1:4000/auth/authorize/callback",
            authorize_url: site <> "/v1/authorize",
            token_url: site <> "/v1/token"
        ])
        |> OAuth2.Client.put_serializer("application/json", Jason)
    end

    def authorize_url! do
        uri = OAuth2.Client.authorize_url!(client(), response_type: "code", scope: "openid profile")
        |> URI.parse()
        |> URI.to_string()
        uri = "#{uri}&state=#{Base.encode16(:crypto.strong_rand_bytes(12))}&nonce=98aGa"
    end

    def get_token!(params \\ [], headers \\ [], opts \\ []) do
        OAuth2.Client.get_token!(client(), params, headers, opts)
    end

    def authorize_url(client, params) do
        OAuth2.Strategy.AuthCode.authorize_url(client, params)
    end

    def get_token(client, params, headers) do
        client
        |> put_header("accept", "application/json")
        |> OAuth2.Strategy.AuthCode.get_token(params, headers)
        |> IO.inspect
    end
end