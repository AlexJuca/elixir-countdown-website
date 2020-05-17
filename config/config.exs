# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :countdown,
  ecto_repos: [Countdown.Repo]

# Configures the endpoint
config :countdown, CountdownWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "D/d18qArzgr4WJNtklKHhTV0yC15HkbWueaD1JK3e9HgNzAfNldxvchSrTcRc0Xy",
  render_errors: [view: CountdownWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Countdown.PubSub,
  live_view: [signing_salt: "rtvWNCR"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
