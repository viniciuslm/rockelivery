import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :rockelivery, Rockelivery.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "rockelivery_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :rockelivery, RockeliveryWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "TlMS58S3OohJ0VEds33ZOU9Yc3Znp92WZryhCfscUAiIFKvj14VA8H+eAdiCzrGh",
  server: false

# In test we don't send emails.
config :rockelivery, Rockelivery.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :rockelivery, Rockelivery.Users.Create, via_cep_adapter: Rockelivery.ViaCep.ClientMock

config :rockelivery, Rockelivery.Users.Update, via_cep_adapter: Rockelivery.ViaCep.ClientMock

# # Use mock adapter for all clients
# config :tesla, adapter: Tesla.Mock

# # or only for one
# config :tesla, MyApi, adapter: Tesla.Mock
