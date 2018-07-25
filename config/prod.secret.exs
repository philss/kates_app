use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :kates_app, KatesAppWeb.Endpoint,
  secret_key_base: "g2PMRFCpQGVO274Vr1Rwyfl8ZN6DirQbuiQGRpYORVvYK9sinTURtjfwLKVh4T1a"

# Configure your database
config :kates_app, KatesApp.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "kates_app_prod",
  pool_size: 15
