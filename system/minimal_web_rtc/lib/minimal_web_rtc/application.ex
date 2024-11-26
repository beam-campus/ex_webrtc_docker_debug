defmodule MinimalWebRtc.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    IO.puts("Hello from MinimalWebRtc.Application!!")

    children = [
      # Starts a worker by calling: MinimalWebRtc.Worker.start_link(arg)
      # {MinimalWebRtc.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MinimalWebRtc.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
