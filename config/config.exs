# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :imageyard, Imageyard.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "6bi3luzzD6W4AE6/3mnHCDzqC7JNLuDtoeRpnLNUFEUDlGdXppiUKqobnGJLUQv0",
  debug_errors: false,
  pubsub: [name: Imageyard.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, Imageyard.Router,
  parsers: [parsers: [:urlencoded, :multipart, :json],
            accept: ["*/*"],
            json_decoder: Poison,
            length: 100_000_000]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
