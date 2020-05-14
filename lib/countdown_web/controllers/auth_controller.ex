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
      client = Okta.get_token!(code: code)
      IO.inspect client
      conn
      |> send_resp(200, "")
    end
end
