use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :conway, Conway.Endpoint,
  secret_key_base: "QfZwUT60y46BIZ/j/A+7iNbFeBBpSrTn/WI2VYLna7ZPwGBVEGRFJBcU+32zxS/D"

# Configure your database
config :conway, Conway.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "conway_prod"
