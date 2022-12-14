# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :githubex,
  ecto_repos: [Githubex.Repo]

config :githubex, Githubex.Repo,
  migration_primary_key: [type: :binary_id],
  migration_foreign_key: [type: :binary_id]

config :githubex, GithubexWeb.Auth.Guardian,
  issuer: "githubex",
  secret_key: "9a+fTZl2T7uMOZceGYwx4sGbgQuyBZKAgrMrtxccsGikJmLtkt4llpArA4xtbWG8"

config :githubex, GithubexWeb.Auth.Pipeline,
  module: GithubexWeb.Auth.Guardian,
  error_handler: GithubexWeb.Auth.ErrorHandler

# Configures the endpoint
config :githubex, GithubexWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: GithubexWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Githubex.PubSub,
  live_view: [signing_salt: "lxDIwLs8"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :githubex, Githubex.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
