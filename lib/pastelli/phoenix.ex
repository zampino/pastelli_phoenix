defmodule Pastelli.Phoenix do
  @moduledoc """
    allows Phoenix to run over Pastelli
  """

  @behaviour Phoenix.Endpoint.Handler

  def child_spec(scheme, endpoint, config) do
    Pastelli.child_spec(scheme, endpoint, [], config)
  end

end
