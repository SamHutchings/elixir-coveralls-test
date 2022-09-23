defmodule ElixirCoverallsTest.MixProject do
  use Mix.Project

  @test_envs [:test, :unit_test]

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
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

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
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
