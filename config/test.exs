import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :brick_script_collective, BrickScriptCollectiveWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "bfwNzrmdBRPCM4HYtW2Wil8CnfXOptocGCvWrmcYLQuKgSoTJVP9/Y269Vfz9Nlo",
  server: false

# In test we don't send emails.
config :brick_script_collective, BrickScriptCollective.Mailer,
  adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
