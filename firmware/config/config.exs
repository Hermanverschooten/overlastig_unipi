# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Customize the firmware. Uncomment all or parts of the following
# to add files to the root filesystem or modify the firmware
# archive.

config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"
#   fwup_conf: "config/fwup.conf"

# Use shoehorn to start the main application. See the shoehorn
# docs for separating out critical OTP applications such as those
# involved with firmware updates.
config :shoehorn,
  init: [:nerves_runtime, :nerves_init_gadget],
  app: Mix.Project.config()[:app]

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

config :nerves_firmware_ssh,
  authorized_keys: [ File.read!(Path.join(System.user_home!, ".ssh/id_rsa.pub")) ]

config :nerves_network, :default,
  eth0: [
    ipv4_address_method: :dhcp
  ]

config :user_interface, UserInterfaceWeb.Endpoint,
  http: [port: 80],
  url: [host: "localhost", port: 80],
  root: Path.dirname(__DIR__),
  render_errors: [accepts: ~w(html json)],
  server: true,
  secret_key_base: "w/UQt/HdDpkYTMdk5uwV3kiYqET7GH0KVU6nmCACm6cIvoajaHCKk4CJPHjb4k2W",
  check_origin: false,
  pubsub: [
    name: UserInterfaceWeb.PubSub,
    adapter: Phoenix.PubSub.PG2
  ]

config :unipi, path: "/root/storage/"

config :logger,
  level: :debug,
  backends: [RingLogger]

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.Project.config[:target]}.exs"
