defmodule CountdownWeb.AuthController do
    use CountdownWeb, :controller
    alias CountdownWeb.Router.Helpers
    alias Countdown.Accounts.Auth
    alias Countdown.Repo
    alias CountdownWeb.UserView
    alias Countdown.Accounts.User
    alias Countdown.Accounts

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
      changeset = Accounts.change_user(%User{})
      if Auth.user_with_email_exists(user["email"], Repo) do
        conn
        |> put_session(:current_user, user)
        |> put_session(:access_token, client.token.access_token)
        |> put_flash(:info, "Welcome #{user["given_name"]}")
        |> redirect(to: "/")
      else
        conn
        |> put_session(:okta_user, user)
        |> put_session(:access_token, client.token.access_token)
        |> render(
                  UserView, "new.html", 
                  okta_user: get_session(conn, :okta_user),
                  current_user: nil,
                  changeset: changeset
                )
      end
    end
end
