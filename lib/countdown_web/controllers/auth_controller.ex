defmodule CountdownWeb.AuthController do
    use CountdownWeb, :controller
    alias CountdownWeb.Router.Helpers

    plug Ueberauth

    alias Ueberauth.Strategy.Helpers

    def logout(conn, _params) do
      conn
      |> put_flash(:info, "You have been logged out!")
      |> configure_session(drop: true)
      |> redirect(to: "/")
    end

    def callback(%{assigns: %{ ueberauth_failure: fails}}, conn) do
      conn
      |> put_flash(:error, "Failed to authenticate.")
      |> redirect(to: "/")
    end

    def callback(%{ assigns: %{ ueber_auth: auth} }, conn) do
      case UserFromAuth.find_or_create(auth) do
        {:ok, user} -> 
          conn
          |> put_flash(:info, "Successfully authenticated as " <> user.name <> ".")
          |> put_session(:current_user, user)
          |> redirect(to: "/")
        {:error, reason} -> 
            conn
            |> put_flash(:error, reason)
            |> redirect(to: "/")
      end
    end
end
