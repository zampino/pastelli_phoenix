# Pastelli.Phoenix

Allows Phoenix Framework to run over the [Elli](//github.com/knutin/elli) server through [Pastelli](//github.com/zampino/pastelli) plug adapter.

:construction: this is work in progress // in order for `Pastelli.Phoenix`
to work, Phoenix Framework would need [some changes](//github.com/zampino/phoenix/pull/1) to be merged
first ... :construction:

## Instructions

Add `:pastelli_phoenix` to your phoenix app dependencies

### Mix it in your Phoenix Application

```elixir
def deps do
  [
    {:phoenix, "~> 1.0.4"},
    {:pastelli_phoenix, "~> 0.1.0", github: "zampino/pastelli_phoenix" },
    # ...
  ]
end
```

### Configure your App

in `config.exs` or `[env].exs`

```elixir
config :my_app, MyApp.Endpoint,
  http: [
    handler: Pastelli.Phoenix,
    port: {:system, "PORT"},
    # ...
  ]
```

### Plug Pastelli Phoenix in your Endpoint

Using `Pastelli.Phoenix.Endpoint` _before_ `Phoenix.Endpoint` module,
a new plug module will be defined at compile time
with the alias `MyApp.Endpoint.SocketDispatch`.

This is to be plugged (anywhere you like but _before_ `MyApp.Router`)
and will convert phoenix socket cowboy-dispatch rules into Pastelli
_standard_ route dispatches which will hand the connection over to [Elli Websocket](//github.com/zampino/pastelli#web-sockets).

Just like this:

```elixir

defmodule MyApp.Endpoint do
  use Pastelli.Phoenix.Endpoint
  use Phoenix.Endpoint, otp_app: :chat

  plug MyApp.Endpoint.SocketDispatchRouter

  socket "/socket", MyApp.UserSocket

  plug Plug.Static,
    at: "/", from: :my_app,
    only: ~w(css images js favicon.ico robots.txt)

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.CodeReloader
    plug Phoenix.LiveReloader
  end

  # ... and the usual user defined plug pipeline

  plug MyApp.Router
end
```

See this in Action in the [default phoenix chat example](//github.com/zampino/phoenix-over-pastelli).
