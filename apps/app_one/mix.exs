defmodule AppOne.MixProject do
  use Mix.Project

  @test_envs [:test, :unit_test]

  def project do
    [
      app: :app_one,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        unit_test_coverage: :unit_test
      ],
      test_paths: test_paths(Mix.env())
    ]
  end

  defp test_paths(:test), do: ["test"]
  defp test_paths(:unit_test), do: ["unit_test"]
  defp test_paths(_), do: []

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:excoveralls, "~> 0.14", only: @test_envs}
    ]
  end

  defp aliases do
    [
      unit_test_coverage: &unit_test_coverage/1
    ]
  end

  defp unit_test_coverage(args) do
    args = if IO.ANSI.enabled?(), do: ["--color" | args], else: ["--no-color" | args]
    mix_command = ["coveralls.post", "--no-start"] ++ args

    Mix.shell().info("==> Running `mix #{Enum.join(mix_command, " ")}` with `MIX_ENV=unit_test`")

    {_, res} =
      System.cmd("mix", mix_command,
        into: IO.binstream(:stdio, :line),
        env: [{"MIX_ENV", "unit_test"}]
      )

    if res > 0 do
      System.at_exit(fn _ -> exit({:shutdown, 1}) end)
    end
  end
end
