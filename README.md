# Pastelli.Phoenix

Let Phoenix Framework run over the [Elli](//github.com/knutin/elli) server through [Pastelli](//github.com/zampino/pastelli) plug adapter
and [elli_websocket](https://github.com/mmzeeman/elli_websocket).

As of Phoenix at version greater or equal than `1.1.0`,
the framework allows for third party plug adapters to be fitted inside the
application supervision tree. This project implements
[`Phoenix.Endpoint.Handler`](https://github.com/phoenixframework/phoenix/blob/master/lib/phoenix/endpoint/handler.ex) behaviour for Pastelli.

See this in Action in a fork of the [default phoenix chat example](//github.com/zampino/phoenix-on-pastelli).

## Instructions

Add `:pastelli_phoenix` to your phoenix app dependencies

### Mix it in your Phoenix Application

```elixir
def deps do
  [
    {:phoenix, "~> 1.4.0"},
    {:pastelli_phoenix, "~> 0.1.0", github: "zampino/pastelli_phoenix" },
    # ...
  ]
end
```

### Configure your App

in `config.exs` or `[env].exs`

```elixir
config :my_app, MyApp.Endpoint,
  handler: Pastelli.Phoenix,
  http: [
    port: {:system, "PORT"},
    # ...
  ]
```

like in [here](https://github.com/zampino/phoenix-on-pastelli/blob/master/config/config.exs#L11).

### Plug Pastelli.Phoenix in your Endpoint

In your application endpoint use [`Pastelli.Phoenix.Endpoint`](https://github.com/zampino/pastelli_phoenix/blob/master/lib/pastelli/phoenix/endpoint.ex) module _before_ the usual `Phoenix.Endpoint`.

A new plug module will be defined at compile time
with the alias `Pastelli.Phoenix.SocketDispatchRouter`.
This is to be plugged (anywhere you like but _before_ `MyApp.Router` of course)
and will convert phoenix sockets from cowboy-dispatch rules into Pastelli
_standard_ route dispatches. Pastelli will hand ws-upgrade
connections over to elli_websocket.

Just like this:

```elixir

defmodule MyApp.Endpoint do
  use Pastelli.Phoenix.Endpoint
  use Phoenix.Endpoint, otp_app: :chat

  plug Pastelli.Phoenix.SocketDispatchRouter

  socket "/socket", MyApp.UserSocket

  plug Plug.Static,
    at: "/", from: :my_app,
    only: ~w(css images js favicon.ico robots.txt)

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.CodeReloader
    plug Phoenix.LiveReloader
  end

  # ... and the usual plug pipeline

  plug MyApp.Router
end
```
