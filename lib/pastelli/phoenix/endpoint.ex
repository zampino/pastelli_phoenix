defmodule Pastelli.Phoenix.Endpoint do

  defmacro __using__(_ops) do
    quote do
      @before_compile Pastelli.Phoenix.Endpoint
    end
  end

  defmacro __before_compile__(env) do
    sockets = Module.get_attribute(env.module, :phoenix_sockets)
    quote do
      unquote build_socket_router(env.module, sockets)
    end
  end

  defp build_socket_router(endpoint, sockets) do

    dispatch_routes = for {path, socket} <- sockets,
      {transport, {module, _config}} <- socket.__transports__,
      do: {Path.join(path, Atom.to_string(transport)),
           Macro.escape({transport, module, endpoint, socket})}

    quote bind_quoted: [dispatch_routes: dispatch_routes] do
      defmodule SocketDispatchRouter do
        require Logger
        import Pastelli.Phoenix.Endpoint, only: [route_body_for: 1]
        use Plug.Router

        Plug.Builder.plug :match
        Plug.Builder.plug :dispatch

        for {path, args} <- dispatch_routes do
          get path, do: route_body_for(unquote(args))
        end

        match _ do
          var!(conn)
        end

      end
    end
  end

  defmacro route_body_for {:websocket, module, endpoint, socket_handler} do
    quote bind_quoted: [
      module: module,
      endpoint: endpoint,
      socket_handler: socket_handler
    ] do
      {:ok, conn, handler_config} = module.init(var!(conn), {endpoint, socket_handler, :websocket})

      put_private(conn, :upgrade, {:websocket, Pastelli.Phoenix.Websocket})
      |> put_private(:websocket_transport, handler_config)
      |> halt
    end
  end

  defmacro route_body_for {:longpoll, _m, _e, _s} do
    quote do
      Logger.info "||[ LongPoll Not Supported ]||"
      halt(var!(conn))
    end
  end
end
