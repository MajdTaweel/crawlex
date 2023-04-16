defmodule Crawlex.Repo.Migrations.CreateSites do
  use Ecto.Migration

  def change do
    create table(:sites) do
      add :base_url, :string
      add :browser_rendering, :boolean, default: false, null: false
      add :country_code, :string
      add :cookies, :map
      add :name, :string
      add :query_parameters, :map
      add :selectors, :map
      add :wait_for_js, {:array, :string}
      add :wait_for_selectors, {:array, :string}

      timestamps()
    end

    create unique_index(:sites, [:base_url])
  end
end
