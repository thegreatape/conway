use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :conway, Conway.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :conway, Conway.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "thomas",
  password: "",
  database: "conway_test",
  size: 1,
  max_overflow: false
