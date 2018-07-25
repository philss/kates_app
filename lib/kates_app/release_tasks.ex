defmodule KatesApp.ReleaseTasks do
  @moduledoc """
  This is the module responsible for release tasks, to run migrations and related things
  in production and staging.
  """

  @start_apps [
    :crypto,
    :ssl,
    :postgrex,
    :ecto
  ]

  defp app_name, do: :kates_app

  defp repos, do: Application.get_env(app_name(), :ecto_repos, [])

  def seed do
    # Run migrations
    migrate()

    # Run seed script
    Enum.each(repos(), &run_seeds_for/1)

    # Signal shutdown
    IO.puts("Success!")
    :init.stop()
  end

  def migrate do
    prepare()
    Enum.each(repos(), &run_migrations_for/1)
  end

  defp prepare do
    me = app_name()

    IO.puts("Loading #{me}..")
    # Load the code for app_name, but don't start it
    :ok = Application.load(me)

    IO.puts("Starting dependencies..")
    # Start apps necessary for executing migrations
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    # Start the Repo(s) for app_name
    IO.puts("Starting repos..")
    Enum.each(repos(), & &1.start_link(pool_size: 1))
  end

  defp priv_dir(app), do: "#{:code.priv_dir(app)}"

  defp run_migrations_for(repo) do
    app = Keyword.get(repo.config, :otp_app)
    IO.puts("Running migrations for #{app}")
    Ecto.Migrator.run(repo, migrations_path(repo), :up, all: true)
  end

  defp run_seeds_for(repo) do
    # Run the seed script if it exists
    seed_script = seeds_path(repo)

    if File.exists?(seed_script) do
      IO.puts("Running seed script..")
      Code.eval_file(seed_script)
    end
  end

  defp migrations_path(repo), do: priv_path_for(repo, "migrations")

  defp seeds_path(repo), do: priv_path_for(repo, "seeds.exs")

  defp priv_path_for(repo, filename) do
    app = Keyword.get(repo.config, :otp_app)
    repo_underscore = repo |> Module.split() |> List.last() |> Macro.underscore()
    Path.join([priv_dir(app), repo_underscore, filename])
  end
end
