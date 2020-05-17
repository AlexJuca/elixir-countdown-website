defmodule Countdown.Accounts.Auth do
    alias Countdown.Accounts.User

    def user_with_email_exists(email, repo) do
        user = repo.get_by(User, email: String.downcase(email))
        if user do
            true
        else 
            false
        end
    end
end