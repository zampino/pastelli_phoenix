defmodule Pastelli.Phoenix.Websocket do
  @behaviour :elli_websocket_handler
  require Logger

  def websocket_init(req, conn: %Plug.Conn{} = conn) do
    Process.flag(:trap_exit, true)
    %Plug.Conn{private: %{websocket_transport: {handler, args}}} = conn
    {:ok, state, timeout} = handler.ws_init args
    {:ok, [], timeout, {handler, state}}
  end

  def websocket_handle(_req, {:text, payload}, {handler, state}) do
    # Logger.info "[WS:HANDLE:TEXT]\n#{inspect handler}\n#{inspect state}"
    handle handler.ws_handle(:text, payload, state), handler
  end

  def websocket_handle(_req, {:binary, payload}, {handler, state}) do
    # Logger.info "[WS:HANDLE:BINARY]\n#{inspect handler}\n#{inspect state}"
    handle handler.ws_handle(:binary, payload, state), handler
  end

  def websocket_handle(_req, other, {handler, state}) do
    # Logger.info "[WS:HANDLE]\n#{inspect other}"
    {:ok, {handler, state}}
  end

  def websocket_info(req, message, {handler, state}) do
    # Logger.info "[WS:INFO]\nmessage: #{inspect message}"
    handle handler.ws_info(message, state), handler
  end

  # events

  def websocket_handle_event(:websocket_close, _args, {handler, state}) do
    res = handler.ws_close(state)
    Logger.info "[WS:EVENT:CLOSE]\n#{inspect(res)}"
    :ok
  end

  def websocket_handle_event(:websocket_error, args, _state) do
    Logger.error "[WS:EVENT:ERROR]\n#{inspect(args)}" #"\n#{inspect state}"
    exit(:ws_error)
  end

  def websocket_handle_event(event, args, state) do
    Logger.debug "[WS:EVENT:#{inspect(event)}]\n#{inspect(args)}\n#{inspect state}"
    :ok
  end

  defp handle({:ok, new_state}, handler) do
    # Logger.info "[WS:NOREPLY]\n#{inspect new_state}"
    {:ok, {handler, new_state}}
  end

  defp handle({:reply, {opcode, payload}, new_state}, handler) do
    # Logger.info "[WS:REPLY]\n#{inspect {opcode, payload}}"
    {:reply, {opcode, payload}, {handler, new_state}}
  end
end
