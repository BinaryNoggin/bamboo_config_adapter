defmodule BambooConfigAdapter.MixProject do
  use Mix.Project

  @project_url "https://github.com/BinaryNoggin/bamboo_config_adapter"

  def project do
    [
      app: :bamboo_config_adapter,
      version: "0.1.0",
      elixir: "~> 1.6",
      source_url: @project_url,
      homepage_url: @project_url,
      name: "Bamboo Config Adapter",
      description: "A Bamboo adapter for runtime configurations",
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      package: package(),
      docs: [main: "readme", extras: ["README.md"]],
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:bamboo, "~> 0.8"},
      {:mix_test_watch, "~> 0.5", only: :dev, runtime: false},
      {:credo, "~> 0.8.10", only: [:dev, :test]},
      {:earmark, ">= 1.0.3", only: :dev},
      {:ex_doc, "~> 0.16.2", only: :dev},
      {:excoveralls, "~> 0.7.1", only: :test}
    ]
  end

  defp package do
    [
      maintainers: ["Amos King @adkron <amos@binarynoggin.com>"],
      licenses: ["MIT"],
      links: %{"GitHub" => @project_url}
    ]
  end
end
