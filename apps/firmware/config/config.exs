# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :user_interface, UserInterface.Endpoint,
  http: [port: 80],
  url: [host: "localhost", port: 80],
  root: Path.dirname(__DIR__),
  render_errors: [accepts: ~w(html json)],
  server: true,
  cache_static_manifest: "priv/static/manifest.json",
  secret_key_base: "w/UQt/HdDpkYTMdk5uwV3kiYqET7GH0KVU6nmCACm6cIvoajaHCKk4CJPHjb4k2W",
  check_origin: false,
  pubsub: [name: UserInterface.PubSub,
    adapter: Phoenix.PubSub.PG2]

config :logger, level: :debug

