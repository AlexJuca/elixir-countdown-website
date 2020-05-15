defmodule CountdownWeb.AuthController do
    use CountdownWeb, :controller
    alias CountdownWeb.Router.Helpers

    def logout(conn, _params) do
      conn
      |> put_flash(:info, "You have been logged out!")
      |> configure_session(drop: true)
      |> redirect(to: "/")
    end

    def request(conn, params) do
      url = Okta.authorize_url!()
      IO.inspect url
      conn
      |> redirect(external: url)
    end

    def callback(conn, %{"provider" => provider, "code" => code, "state" => state}) do
      client = Okta.get_token_without_auth!(code: code)
      {:ok, resp} = Okta.get_user_info(client)
      user = resp.body
      conn
      |> put_session(:current_user, user)
      |> put_session(:access_token, client.token.access_token)
      |> put_flash(:info, "Welcome #{user["given_name"]}")
      |> redirect(to: "/")
    end
end
