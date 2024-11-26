defmodule MinimalWebRtc.MixProject do
  use Mix.Project

  def project do
    [
      app: :minimal_web_rtc,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: releases()
    ]
  end

  defp releases do
    [
      minimal_web_rtc: [
        include_executables_for: [:unix],
        steps: [:assemble, :tar],
        applications: [
          runtime_tools: :permanent,
          logger: :permanent,
          observer: :permanent,
          os_mon: :permanent,
          minimal_web_rtc: :permanent
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {MinimalWebRtc.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_webrtc, "~> 0.6.3"},
      {:ex_sctp, "~> 0.1.1", override: true}
    ]
  end
end
