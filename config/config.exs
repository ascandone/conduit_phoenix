# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :conduit,
  namespace: Conduit,
  ecto_repos: [Conduit.Repo]

# Configures the endpoint
config :conduit, ConduitWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: ConduitWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Conduit.PubSub,
  live_view: [signing_salt: "eihHJYcd"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

config :conduit, Conduit.Guardian,
  issuer: "conduit",
  # TODO move to env?
  secret_key: "Y8Z6RUdazHMcXcyD8BftznvhRVW3DiTbSkIXQliob9vJlXFnj7eL+2cRnaRVTzbD"
