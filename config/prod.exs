import Config

# Configures Swoosh API Client
config :swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: LatodoApi.Finch

# Disable Swoosh Local Memory Storage
config :swoosh, local: false

# Do not print debug messages in production
config :logger, level: :info

config :latodo_api, LatodoApiWeb.Endpoint,
  load_from_system_env: true, # Expects url host and port to be configured in Endpoint.init callback
  url: [host: "example.com", port: 80]

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.
