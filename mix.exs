defmodule ExEarlyRet.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_early_ret,
      name: "ex_early_ret",
      description: "An Elixir macro for limited early return (expands to nested if-else)",
      source_url: "https://github.com/myfreeweb/ex_early_ret",
      version: "0.1.1",
      elixir: "~> 1.7",
      deps: deps(),
      package: package()
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:ex_doc, "~> 0.18", only: [:dev, :test, :docs]}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "CODE_OF_CONDUCT.md", "UNLICENSE"],
      maintainers: ["Greg V"],
      licenses: ["Unlicense"],
      links: %{"GitHub" => "https://github.com/myfreeweb/ex_early_ret"}
    ]
  end
end
