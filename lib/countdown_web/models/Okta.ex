defmodule Okta do
    use ExOAuth2.Strategy

    def client do
        site = System.get_env("OKTA_DOMAIN")
        ExOAuth2.Client.new([
            strategy: __MODULE__,
            client_id: System.get_env("OKTA_CLIENT_ID"),
            client_secret: System.get_env("OKTA_CLIENT_SECRET"),
            site: site,
            redirect_uri: "http://127.0.0.1:4000/auth/authorize/callback",
            authorize_url: site <> "/v1/authorize",
            token_url: site <> "/v1/token"
        ])
        |> ExOAuth2.Client.put_serializer("application/json", Jason)
    end

    def authorize_url! do
        uri = ExOAuth2.Client.authorize_url!(client(), response_type: "code", scope: "openid profile email", idp: "0oabpjs7kGojVfWuJ4x6")
        |> URI.parse()
        |> URI.to_string()
        "#{uri}&state=#{Base.encode16(:crypto.strong_rand_bytes(12))}&nonce=98aGa"
    end

    def get_token_without_auth!(params \\ [], headers \\ [], opts \\ []) do
        client = client()
        headers = List.keystore(headers, "accept", 1, {"accept", "*/*"})
        params = Keyword.put(params, :client_secret, client.client_secret)
        ExOAuth2.Client.get_token_without_auth!(client, params, headers, opts)
        |> IO.inspect
    end

    def get_token!(params \\ [], headers \\ [], opts \\ []) do
        client = client()
        params = Keyword.put(params, :client_secret, client.client_secret)
        ExOAuth2.Client.get_token!(client, params, headers, opts)
        |> IO.inspect
    end

    def authorize_url(client, params) do
        ExOAuth2.Strategy.AuthCode.authorize_url(client, params)
    end

    def get_token_without_auth(client, params, headers) do
        client
        |> ExOAuth2.Strategy.AuthCode.get_token_without_auth(params, headers)
        |> IO.inspect
    end

    def get_token(client, params, headers) do
        client
        |> ExOAuth2.Strategy.AuthCode.get_token(params, headers)
        |> IO.inspect
    end

    def get_user_info(client, headers \\ [], opts \\ []) do
        headers = List.keystore(headers, "authorization", 1, {"authorization", "Bearer " <> client.token.access_token})
        client
        |> ExOAuth2.Client.get(client.site <> "/v1/userinfo", headers, opts)
        |> IO.inspect
    end
end